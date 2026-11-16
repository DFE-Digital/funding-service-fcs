using Microsoft.Identity.Client;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;

namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Services
{
    public static class SharePointAuthenticationHelper
    {
        private static readonly string Tenant =
            TestConfiguration.Configuration["SharePoint:OAuth:Tenant"];

        private static readonly string ClientId =
            TestConfiguration.Configuration["SharePoint:OAuth:ClientId"];

        private static readonly string ClientSecret =
            !string.IsNullOrWhiteSpace(TestConfiguration.Configuration["SharePoint:OAuth:ClientSecret"])
                ? TestConfiguration.Configuration["SharePoint:OAuth:ClientSecret"]
                : Environment.GetEnvironmentVariable("SP_CLIENT_SECRET");


        private static readonly string SiteUrl =
            TestConfiguration.Configuration["AzureAd:Resource"];

        // --------------------------------------------------------------------
        //  LEGACY SIGNATURE to prevent breaking callers using GetClientContext()
        //  (CSOM is not used under the hood for Graph ops; this is a no-op shell)
        // --------------------------------------------------------------------
        public static Microsoft.SharePoint.Client.ClientContext GetClientContext()
        {
            // Keep returning a context so existing "using (GetClientContext())" compiles,
            // but all file/folder operations should be done via *Graph* methods below.
            return new Microsoft.SharePoint.Client.ClientContext(SiteUrl);
        }

        // --------------------------------------------------------------------
        //  GRAPH TOKEN (Client Credentials / Application permissions)
        // --------------------------------------------------------------------
        public static string GetGraphAccessToken()
        {
            var app = ConfidentialClientApplicationBuilder.Create(ClientId)
                .WithClientSecret(ClientSecret)
                .WithAuthority("https://login.microsoftonline.com/" + Tenant)
                .Build();

            var scopes = new[] { "https://graph.microsoft.com/.default" };
            var result = app.AcquireTokenForClient(scopes)
                            .ExecuteAsync()
                            .GetAwaiter()
                            .GetResult();

            return result.AccessToken;
        }

        /// <summary>
        /// Delete all files starting with ukPrn inside the given folder (document library path),
        /// e.g. office365Location = "Shared Documents/Path/To/Folder"
        /// </summary>
        public static void RemoveFilesByPrefix_Graph(string office365Location, string ukPrn)
        {
            ExecuteWithHttpClient(delegate (HttpClient http)
            {
                var siteId = ResolveSiteId(http);
                if (string.IsNullOrEmpty(siteId)) return;

                string driveId, folderId;
                if (!ResolveDriveAndFolder(http, siteId, office365Location, out driveId, out folderId)) return;

                // Get children
                var childrenUrl = "https://graph.microsoft.com/v1.0/drives/" + driveId + "/items/" + folderId + "/children";
                var children = GetJson(http, childrenUrl);
                if (children == null) return;

                var arr = children["value"] as JArray;
                if (arr == null || arr.Count == 0) return;

                foreach (var item in arr)
                {
                    var name = item["name"] != null ? item["name"].ToString() : null;
                    if (!string.IsNullOrEmpty(name) &&
                        name.StartsWith(ukPrn, StringComparison.OrdinalIgnoreCase))
                    {
                        var id = item["id"].ToString();
                        var deleteUrl = "https://graph.microsoft.com/v1.0/drives/" + driveId + "/items/" + id;
                        Delete(http, deleteUrl);
                    }
                }
            });
        }

        /// <summary>
        /// Returns true if file with exact name exists in the given folder.
        /// </summary>
        public static bool FileExists_Graph(string folderPath, string fileName)
        {
            bool found = false;

            ExecuteWithHttpClient(delegate (HttpClient http)
            {
                var siteId = ResolveSiteId(http);
                if (string.IsNullOrEmpty(siteId)) { found = false; return; }

                string driveId, folderId;
                if (!ResolveDriveAndFolder(http, siteId, folderPath, out driveId, out folderId)) { found = false; return; }

                // Filter by name (OData)
                var url = "https://graph.microsoft.com/v1.0/drives/" + driveId + "/items/" + folderId + "/children?$filter=name eq '" + fileName.Replace("'", "''") + "'";
                var resp = GetJson(http, url);

                var arr = resp != null ? resp["value"] as JArray : null;
                found = (arr != null && arr.Count > 0);
            });

            return found;
        }

        public static void DeleteAndRecreateLibrary_Graph(string documentLibraryDisplayName)
        {
            ExecuteWithHttpClient(delegate (HttpClient http)
            {
                var siteId = ResolveSiteId(http);
                if (string.IsNullOrEmpty(siteId)) return;

                // Try delete the list by displayName (need to find its list-id first)
                var listsUrl = "https://graph.microsoft.com/v1.0/sites/" + siteId + "/lists?$filter=displayName eq '" + documentLibraryDisplayName.Replace("'", "''") + "'";
                var lists = GetJson(http, listsUrl);
                var listArr = lists != null ? lists["value"] as JArray : null;

                if (listArr != null && listArr.Count > 0)
                {
                    var listId = listArr[0]["id"].ToString();
                    var delUrl = "https://graph.microsoft.com/v1.0/sites/" + siteId + "/lists/" + listId;
                    Delete(http, delUrl);
                }

                // Recreate
                var createBody = new JObject
                {
                    ["displayName"] = documentLibraryDisplayName,
                    ["list"] = new JObject
                    {
                        ["template"] = "documentLibrary"
                    }
                };

                var createUrl = "https://graph.microsoft.com/v1.0/sites/" + siteId + "/lists";
                PostJson(http, createUrl, createBody);
            });
        }

        // --------------------------------------------------------------------
        //  INTERNAL HELPERS (HttpClient + JSON via Newtonsoft)
        // --------------------------------------------------------------------

        private static void ExecuteWithHttpClient(Action<HttpClient> action)
        {
            var token = GetGraphAccessToken();

            using (var http = new HttpClient())
            {
                http.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
                http.DefaultRequestHeaders.Accept.Clear();
                http.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                action(http);
            }
        }

        private static JObject GetJson(HttpClient http, string url)
        {
            var resp = http.GetAsync(url).GetAwaiter().GetResult();
            if (!resp.IsSuccessStatusCode)
            {
                return null;
            }

            var content = resp.Content.ReadAsStringAsync().GetAwaiter().GetResult();
            if (string.IsNullOrWhiteSpace(content))
                return null;

            try
            {
                return JObject.Parse(content);
            }
            catch (JsonReaderException)
            {
                return null;
            }
        }

        private static JObject PostJson(HttpClient http, string url, JObject payload)
        {
            var json = payload != null ? payload.ToString(Formatting.None) : "{}";
            var content = new StringContent(json, Encoding.UTF8, "application/json");

            var resp = http.PostAsync(url, content).GetAwaiter().GetResult();
            var body = resp.Content.ReadAsStringAsync().GetAwaiter().GetResult();

            if (!resp.IsSuccessStatusCode)
            {
                return null;
            }

            return string.IsNullOrWhiteSpace(body) ? null : JObject.Parse(body);
        }

        private static bool Delete(HttpClient http, string url)
        {
            var resp = http.DeleteAsync(url).GetAwaiter().GetResult();
            // 204 NoContent or 200 OK are typical
            return resp.IsSuccessStatusCode;
        }

        private static string ResolveSiteId(HttpClient http)
        {
            // Graph "sites:byPath" requires: /sites/{hostname}:/sites/{path}
            var siteUri = new Uri(SiteUrl);
            var host = siteUri.Host;                 // xxx.sharepoint.com
            var path = siteUri.AbsolutePath;         // /sites/fct-dat
            if (!path.StartsWith("/")) path = "/" + path;

            var sitesUrl = "https://graph.microsoft.com/v1.0/sites/" + host + ":/sites" + path;
            var site = GetJson(http, sitesUrl);
            return site != null && site["id"] != null ? site["id"].ToString() : null;
        }

        private static bool ResolveDriveAndFolder(HttpClient http, string siteId, string folderPath, out string driveId, out string folderId)
        {
            driveId = null;
            folderId = null;

            var encoded = folderPath.Replace(" ", "%20");
            var url = "https://graph.microsoft.com/v1.0/sites/" + siteId + "/drive/root:/" + encoded;

            var folder = GetJson(http, url);
            if (folder == null) return false;

            var parentRef = folder["parentReference"];
            if (parentRef == null || parentRef["driveId"] == null || folder["id"] == null) return false;

            driveId = parentRef["driveId"].ToString();
            folderId = folder["id"].ToString();
            return true;
        }
    }
}
