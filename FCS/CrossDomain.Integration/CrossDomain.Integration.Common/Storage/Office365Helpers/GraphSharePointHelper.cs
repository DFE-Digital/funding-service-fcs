
namespace SFA.FCT.CrossDomain.Integration.Common.Storage.Office365Helpers
{
    using Newtonsoft.Json.Linq;
    using System;
    using System.Configuration;
    using System.Linq;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;

    public static class GraphSharePointHelper
    {       
        private static void GetHostAndPath(out string host, out string sitePath)
        {
            string resource = ConfigurationManager.AppSettings["ida:Resource"];
            if (string.IsNullOrWhiteSpace(resource))
                throw new InvalidOperationException("AppSetting 'ida:Resource' is required (absolute SharePoint site URL).");

            Uri uri;
            if (!Uri.TryCreate(resource, UriKind.Absolute, out uri))
                throw new InvalidOperationException("ida:Resource must be an absolute SharePoint site URL: " + resource);

            host = uri.Host;
            sitePath = uri.AbsolutePath; // includes leading '/'
        }

        private static string CombinePath(params string[] segments)
        {
            // URL-encode path segments safely (e.g., "Some Date'T'Time")
            return string.Join("/", segments.Select(s => Uri.EscapeDataString(s)));
        }

        public static string ResolveSiteId(HttpClient http)
        {
            string host, sitePath;
            GetHostAndPath(out host, out sitePath);

            using (var resp = http.GetAsync("https://graph.microsoft.com/v1.0/sites/" + host + ":" + sitePath).Result)
            {
                resp.EnsureSuccessStatusCode();
                var j = JObject.Parse(resp.Content.ReadAsStringAsync().Result);
                return (string)j["id"];
            }
        }

        public static string ResolveDriveIdByDisplayName(HttpClient http, string siteId, string libraryDisplayName)
        {
            using (var resp = http.GetAsync("https://graph.microsoft.com/v1.0/sites/" + siteId + "/drives").Result)
            {
                resp.EnsureSuccessStatusCode();
                var j = JObject.Parse(resp.Content.ReadAsStringAsync().Result);
                var drive = j["value"].FirstOrDefault(d =>
                    string.Equals((string)d["name"], libraryDisplayName, StringComparison.OrdinalIgnoreCase));
                if (drive == null)
                    throw new InvalidOperationException("Document library not found: " + libraryDisplayName);
                return (string)drive["id"];
            }
        }

        public static string TryGetItemIdByPath(HttpClient http, string driveId, string[] pathSegments)
        {
            string path = CombinePath(pathSegments);
            var url = "https://graph.microsoft.com/v1.0/drives/" + driveId + "/root:/" + path;

            using (var resp = http.GetAsync(url).Result)
            {
                if (resp.IsSuccessStatusCode)
                {
                    var j = JObject.Parse(resp.Content.ReadAsStringAsync().Result);
                    return (string)j["id"];
                }
                if ((int)resp.StatusCode == 404) return null;
                // throw other errors
                var body = resp.Content.ReadAsStringAsync().Result;
                throw new InvalidOperationException("TryGetItemIdByPath failed: " + (int)resp.StatusCode + " " + resp.ReasonPhrase + " Body: " + body);
            }
        }

        public static string EnsureFolder(HttpClient http, string driveId, string parentItemIdOrNullForRoot, string folderName)
        {
            // Check if it exists
            string existingId;
            if (parentItemIdOrNullForRoot == null)
            {
                existingId = TryGetItemIdByPath(http, driveId, new[] { folderName });
            }
            else
            {
                // list children of parent and find folder
                using (var resp = http.GetAsync("https://graph.microsoft.com/v1.0/drives/" + driveId + "/items/" + parentItemIdOrNullForRoot + "/children?$select=id,name,folder").Result)
                {
                    resp.EnsureSuccessStatusCode();
                    var j = JObject.Parse(resp.Content.ReadAsStringAsync().Result);
                    var match = j["value"].FirstOrDefault(x =>
                        string.Equals((string)x["name"], folderName, StringComparison.OrdinalIgnoreCase) &&
                        x["folder"] != null);
                    if (match != null) existingId = (string)match["id"]; else existingId = null;
                }
            }

            if (!string.IsNullOrEmpty(existingId)) return existingId;

            // Create folder under root or parent
            var body = new JObject();
            body["name"] = folderName;
            body["folder"] = new JObject();
            body["@microsoft.graph.conflictBehavior"] = "replace";

            string url;
            if (parentItemIdOrNullForRoot == null)
            {
                url = "https://graph.microsoft.com/v1.0/drives/" + driveId + "/root/children";
            }
            else
            {
                url = "https://graph.microsoft.com/v1.0/drives/" + driveId + "/items/" + parentItemIdOrNullForRoot + "/children";
            }

            using (var content = new StringContent(body.ToString(), Encoding.UTF8, "application/json"))
            using (var resp = http.PostAsync(url, content).Result)
            {
                resp.EnsureSuccessStatusCode();
                var j = JObject.Parse(resp.Content.ReadAsStringAsync().Result);
                return (string)j["id"];
            }
        }

        public static void UploadSmallFileByPath(HttpClient http, string driveId, string[] pathSegments, byte[] content)
        {
            // PUT /drives/{driveId}/root:/path/to/file:/content
            string path = CombinePath(pathSegments);
            string url = "https://graph.microsoft.com/v1.0/drives/" + driveId + "/root:/" + path + ":/content";

            using (var bytes = new ByteArrayContent(content ?? new byte[0]))
            {
                bytes.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
                using (var resp = http.PutAsync(url, bytes).Result)
                {
                    resp.EnsureSuccessStatusCode();
                }
            }
        }

        public static bool ItemExistsByPath(HttpClient http, string driveId, string[] pathSegments)
        {
            string id = TryGetItemIdByPath(http, driveId, pathSegments);
            return !string.IsNullOrEmpty(id);
        }

        public static void DeleteAllSubFolders(HttpClient http, string driveId, string parentFolderName)
        {
            // Find parent in root
            string parentId = TryGetItemIdByPath(http, driveId, new[] { parentFolderName });
            if (string.IsNullOrEmpty(parentId)) return;

            using (var resp = http.GetAsync("https://graph.microsoft.com/v1.0/drives/" + driveId + "/items/" + parentId + "/children?$select=id,name,folder").Result)
            {
                resp.EnsureSuccessStatusCode();
                var j = JObject.Parse(resp.Content.ReadAsStringAsync().Result);
                foreach (var child in j["value"])
                {
                    if (child["folder"] != null)
                    {
                        string childId = (string)child["id"];
                        using (var del = http.DeleteAsync("https://graph.microsoft.com/v1.0/drives/" + driveId + "/items/" + childId).Result)
                        {
                            // 204 expected
                            if (!del.IsSuccessStatusCode && (int)del.StatusCode != 204)
                            {
                                var body = del.Content.ReadAsStringAsync().Result;
                                throw new InvalidOperationException("Delete child failed: " + (int)del.StatusCode + " " + del.ReasonPhrase + " Body: " + body);
                            }
                        }
                    }
                }
            }
        }
    }
}
