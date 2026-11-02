
namespace CrossDomain.Integration.ReportRunnerEndpoint.Tests.Integration
{
    using System;
    using System.Configuration;
    using System.Linq;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json.Linq;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage.Office365Helpers;
    using Services;

    [TestClass]
    public class ArchiveReportServiceTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ArchiveReportService_ShouldCreateArchiveRootFolderAndChildFolder()
        {
            // arrange
            Office365StorageWrapper office365StorageWrapper = new Office365StorageWrapper(); // wrapper uses robust resolver
            string rootFolder = ConfigurationManager.AppSettings["ReportDelivery.CdaO365Folder"]; // library display name
            DeleteFoldersBelowListName(rootFolder, "Archive");

            ArchiveReportService archiveReportService = new ArchiveReportService(office365StorageWrapper);
            string childFolderName = archiveReportService.GenerateArchiveChildFolderName();

            // act
            archiveReportService.CreateArchiveRootFolderAndChildFolder(childFolderName);

            // assert (Graph-based)
            Assert.IsTrue(DoesFolderExist(rootFolder, "Archive", childFolderName));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Office365Wrapper_ShouldUploadFileContentsToAPathWithSubFolders()
        {
            // Arrange
            byte[] document = new byte[] { 0x31, 0x32, 0x33 }; // "123" (use non-empty)
            string office356Folder = ConfigurationManager.AppSettings["ReportDelivery.CdaO365Folder"]; // library display name
            const string archiveFolder = "Archive";
            const string childOfArchiveFolder = "Some Date'T'Time";

            DeleteFoldersBelowListName(office356Folder, archiveFolder);

            // Ensure Archive/child exists (Graph)
            EnsureFolderPathGraph(office356Folder, archiveFolder, childOfArchiveFolder);

            const string fileName = "test.csv";

            // Act (Graph upload into Archive/childOfArchiveFolder)
            UploadFileToFolderWithSubfoldersGraph(
                office356Folder, archiveFolder, childOfArchiveFolder, document, fileName);

            // Assert
            Assert.IsTrue(DoesFileExist(office356Folder, archiveFolder, childOfArchiveFolder, fileName));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ArchiveReportService_ShouldWriteFileToArchiveFolder()
        {
            // arrange
            Office365StorageWrapper office365StorageWrapper = new Office365StorageWrapper();
            string office356Folder = ConfigurationManager.AppSettings["ReportDelivery.CdaO365Folder"]; // library display name
            DeleteFoldersBelowListName(office356Folder, "Archive");

            ArchiveReportService archiveReportService = new ArchiveReportService(office365StorageWrapper);
            string childFolderName = archiveReportService.GenerateArchiveChildFolderName();

            // Prepare Archive/<child> (Graph) so the service has a target
            EnsureFolderPathGraph(office356Folder, "Archive", childFolderName);

            // Create a source file in library root (Graph) to simulate input
            byte[] document = new byte[] { 0x01, 0x02 };
            const string fileName = "test.test";
            UploadFileToFolder(office356Folder, document, fileName); // uploads to library root via Graph

            // act
            archiveReportService.WriteFileToArchiveFolder(fileName, childFolderName);

            // assert
            Assert.IsTrue(DoesFileExist(office356Folder, "Archive", childFolderName, fileName));
        }

        // -------------------------------
        // Public helpers (same signatures)
        // -------------------------------

        public bool DoesFolderExist(string listName, string folderName, string childFolderName)
        {
            using (var http = AuthenticationHelper.EnsureClient())
            {
                var ids = ResolveIds(http, listName);
                return ItemExistsByPath(http, ids.DriveId, folderName, childFolderName);
            }
        }

        public bool DoesFileExist(string listName, string folderName, string childFolderName, string fileName)
        {
            using (var http = AuthenticationHelper.EnsureClient())
            {
                var ids = ResolveIds(http, listName);
                return ItemExistsByPath(http, ids.DriveId, folderName, childFolderName, fileName);
            }
        }

        public void UploadFileToFolder(string folderName, byte[] content, string fileName)
        {
            using (var http = AuthenticationHelper.EnsureClient())
            {
                var ids = ResolveIds(http, folderName);
                UploadSmallFileByPath(http, ids.DriveId, new[] { fileName }, content ?? new byte[] { 0x20 });
            }
        }

        private static void DeleteFoldersBelowListName(string rootListName, string listName)
        {
            using (var http = AuthenticationHelper.EnsureClient())
            {
                var ids = ResolveIds(http, rootListName);

                // Resolve parent folder under root
                string parentId = TryGetItemIdByPath(http, ids.DriveId, new[] { listName });
                if (string.IsNullOrEmpty(parentId))
                    return;

                // Enumerate children and delete folders (paged)
                string url = "https://graph.microsoft.com/v1.0/drives/" + ids.DriveId + "/items/" + parentId + "/children?$select=id,name,folder";
                while (!string.IsNullOrEmpty(url))
                {
                    using (var resp = http.GetAsync(url).Result)
                    {
                        resp.EnsureSuccessStatusCode();
                        var j = JObject.Parse(resp.Content.ReadAsStringAsync().Result);

                        foreach (var child in j["value"])
                        {
                            if (child["folder"] != null)
                            {
                                string childId = (string)child["id"];
                                using (var del = http.DeleteAsync(
                                    "https://graph.microsoft.com/v1.0/drives/" + ids.DriveId + "/items/" + childId).Result)
                                {
                                    if (!del.IsSuccessStatusCode && (int)del.StatusCode != 204)
                                    {
                                        var body = del.Content.ReadAsStringAsync().Result;
                                        throw new InvalidOperationException(
                                            "Delete child failed: " + (int)del.StatusCode + " " + del.ReasonPhrase + " Body: " + body);
                                    }
                                }
                            }
                        }

                        url = (string)j["@odata.nextLink"];
                    }
                }
            }
        }

        // -------------------------------
        // Internal Graph helpers
        // -------------------------------

        private struct SiteDriveIds
        {
            public string SiteId;
            public string DriveId;
        }
        private static SiteDriveIds ResolveIds(HttpClient http, string libraryDisplayName)
        {
            string host, sitePath;
            ParseSite(out host, out sitePath);

            // Resolve site
            using (var respSite = http.GetAsync("https://graph.microsoft.com/v1.0/sites/" + host + ":" + sitePath).Result)
            {
                respSite.EnsureSuccessStatusCode();
                var siteJson = JObject.Parse(respSite.Content.ReadAsStringAsync().Result);
                string siteId = (string)siteJson["id"];

                // (A) Page through /drives
                string drivesUrl = "https://graph.microsoft.com/v1.0/sites/" + siteId + "/drives?$select=id,name,webUrl,driveType";
                JObject foundDrive = null;

                while (!string.IsNullOrEmpty(drivesUrl) && foundDrive == null)
                {
                    using (var respDrives = http.GetAsync(drivesUrl).Result)
                    {
                        respDrives.EnsureSuccessStatusCode();
                        var j = JObject.Parse(respDrives.Content.ReadAsStringAsync().Result);

                        var page = j["value"]?
                            .Where(d => string.Equals((string)d["driveType"], "documentLibrary", StringComparison.OrdinalIgnoreCase))
                            .Select(d => (JObject)d) ?? Enumerable.Empty<JObject>();

                        // 1) Exact name
                        foundDrive = page.FirstOrDefault(d =>
                            string.Equals((string)d["name"], libraryDisplayName, StringComparison.OrdinalIgnoreCase));

                        // 2) webUrl heuristic
                        if (foundDrive == null)
                        {
                            foundDrive = page.FirstOrDefault(d =>
                                ((string)d["webUrl"])?.IndexOf("/" + libraryDisplayName + "/", StringComparison.OrdinalIgnoreCase) >= 0);
                        }

                        drivesUrl = (string)j["@odata.nextLink"];
                    }
                }

                // (B) Fallback to Lists -> Drive (string template "documentLibrary"), with paging
                if (foundDrive == null)
                {
                    string listsUrl = "https://graph.microsoft.com/v1.0/sites/" + siteId + "/lists?$select=id,name,displayName,list,webUrl";
                    string matchedListId = null;

                    while (!string.IsNullOrEmpty(listsUrl) && matchedListId == null)
                    {
                        using (var respLists = http.GetAsync(listsUrl).Result)
                        {
                            respLists.EnsureSuccessStatusCode();
                            var jLists = JObject.Parse(respLists.Content.ReadAsStringAsync().Result);

                            var docLibs = jLists["value"]?
                                .Where(l => string.Equals((string)l["list"]?["template"], "documentLibrary", StringComparison.OrdinalIgnoreCase))
                                .Select(l => (JObject)l) ?? Enumerable.Empty<JObject>();

                            var match = docLibs.FirstOrDefault(l =>
                                string.Equals((string)l["displayName"], libraryDisplayName, StringComparison.OrdinalIgnoreCase) ||
                                string.Equals((string)l["name"], libraryDisplayName, StringComparison.OrdinalIgnoreCase));

                            if (match != null)
                                matchedListId = (string)match["id"];

                            listsUrl = (string)jLists["@odata.nextLink"];
                        }
                    }

                    if (!string.IsNullOrEmpty(matchedListId))
                    {
                        using (var respDrive = http.GetAsync("https://graph.microsoft.com/v1.0/sites/" + siteId + "/lists/" + matchedListId + "/drive").Result)
                        {
                            respDrive.EnsureSuccessStatusCode();
                            foundDrive = JObject.Parse(respDrive.Content.ReadAsStringAsync().Result);
                        }
                    }
                }

                if (foundDrive == null)
                    throw new InvalidOperationException("Document library not found: " + libraryDisplayName);

                string driveId = (string)foundDrive["id"];
                return new SiteDriveIds { SiteId = siteId, DriveId = driveId };
            }
        }

        private static void EnsureFolderPathGraph(string libraryDisplayName, params string[] segments)
        {
            using (var http = AuthenticationHelper.EnsureClient())
            {
                var ids = ResolveIds(http, libraryDisplayName);
                string parentId = null;

                for (int i = 0; i < segments.Length; i++)
                {
                    string name = segments[i];
                    parentId = EnsureFolder(http, ids.DriveId, parentId, name);
                }
            }
        }

        private static void UploadFileToFolderWithSubfoldersGraph(string libraryDisplayName, string folder, string childFolder, byte[] content, string fileName)
        {
            using (var http = AuthenticationHelper.EnsureClient())
            {
                var ids = ResolveIds(http, libraryDisplayName);

                // Ensure Archive and child
                string parentId = EnsureFolder(http, ids.DriveId, null, folder);
                EnsureFolder(http, ids.DriveId, parentId, childFolder);

                UploadSmallFileByPath(http, ids.DriveId, new[] { folder, childFolder, fileName }, content ?? new byte[] { 0x20 });
            }
        }

        private static bool ItemExistsByPath(HttpClient http, string driveId, params string[] pathSegments)
        {
            string id = TryGetItemIdByPath(http, driveId, pathSegments);
            return !string.IsNullOrEmpty(id);
        }

        private static string TryGetItemIdByPath(HttpClient http, string driveId, string[] pathSegments)
        {
            string path = CombinePath(pathSegments);
            string url = "https://graph.microsoft.com/v1.0/drives/" + driveId + "/root:/" + path;

            using (var resp = http.GetAsync(url).Result)
            {
                if (resp.IsSuccessStatusCode)
                {
                    var j = JObject.Parse(resp.Content.ReadAsStringAsync().Result);
                    return (string)j["id"];
                }
                if ((int)resp.StatusCode == 404) return null;

                var body = resp.Content.ReadAsStringAsync().Result;
                throw new InvalidOperationException("TryGetItemIdByPath failed: " + (int)resp.StatusCode + " " + resp.ReasonPhrase + " Body: " + body);
            }
        }

        private static string EnsureFolder(HttpClient http, string driveId, string parentItemIdOrNullForRoot, string folderName)
        {
            // Check existence
            if (parentItemIdOrNullForRoot == null)
            {
                var existingId = TryGetItemIdByPath(http, driveId, new[] { folderName });
                if (!string.IsNullOrEmpty(existingId)) return existingId;
            }
            else
            {
                // Paged children under the parent
                string url = "https://graph.microsoft.com/v1.0/drives/" + driveId + "/items/" + parentItemIdOrNullForRoot + "/children?$select=id,name,folder";
                while (!string.IsNullOrEmpty(url))
                {
                    using (var resp = http.GetAsync(url).Result)
                    {
                        resp.EnsureSuccessStatusCode();
                        var j = JObject.Parse(resp.Content.ReadAsStringAsync().Result);
                        var match = j["value"].FirstOrDefault(x =>
                            string.Equals((string)x["name"], folderName, StringComparison.OrdinalIgnoreCase) &&
                            x["folder"] != null);
                        if (match != null) return (string)match["id"];

                        url = (string)j["@odata.nextLink"];
                    }
                }
            }

            // Create folder
            var body = new JObject();
            body["name"] = folderName;
            body["folder"] = new JObject();
            body["@microsoft.graph.conflictBehavior"] = "replace";

            string createUrl = parentItemIdOrNullForRoot == null
                ? "https://graph.microsoft.com/v1.0/drives/" + driveId + "/root/children"
                : "https://graph.microsoft.com/v1.0/drives/" + driveId + "/items/" + parentItemIdOrNullForRoot + "/children";

            using (var content = new StringContent(body.ToString(), Encoding.UTF8, "application/json"))
            using (var resp = http.PostAsync(createUrl, content).Result)
            {
                resp.EnsureSuccessStatusCode();
                var j = JObject.Parse(resp.Content.ReadAsStringAsync().Result);
                return (string)j["id"];
            }
        }

        private static void UploadSmallFileByPath(HttpClient http, string driveId, string[] pathSegments, byte[] content)
        {
            string path = CombinePath(pathSegments);
            string url = "https://graph.microsoft.com/v1.0/drives/" + driveId + "/root:/" + path + ":/content";

            using (var bytes = new ByteArrayContent(content ?? new byte[] { 0x20 }))
            {
                bytes.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
                using (var resp = http.PutAsync(url, bytes).Result)
                {
                    resp.EnsureSuccessStatusCode();
                }
            }
        }

        private static string CombinePath(params string[] segments)
        {
            // URL-encode each segment to cope with spaces, quotes, etc.
            return string.Join("/", segments.Select(s => Uri.EscapeDataString(s ?? string.Empty)));
        }

        private static void ParseSite(out string host, out string sitePath)
        {
            string siteUrl = ConfigurationManager.AppSettings["ida:Resource"];
            if (string.IsNullOrWhiteSpace(siteUrl))
                throw new InvalidOperationException("AppSetting 'ida:Resource' must be a full SharePoint site URL (e.g., https://xxx.sharepoint.com/sites/site).");

            Uri uri;
            if (!Uri.TryCreate(siteUrl, UriKind.Absolute, out uri))
                throw new InvalidOperationException("Invalid ida:Resource URL: " + siteUrl);

            host = uri.Host;
            sitePath = uri.AbsolutePath; // includes leading '/'
        }
    }
}
