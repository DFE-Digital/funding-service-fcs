
namespace SFA.FCT.CrossDomain.Integration.Common.Storage
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Globalization;
    using System.Linq;
    using Exceptions;
    using Framework.Logging.Interfaces;
    using Framework.Logging.NullObjects;
    using Newtonsoft.Json.Linq;
    using Office365Helpers;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using SystemIO = System.IO;

    public class Office365StorageWrapper : IOffice365Adapter
    {
        private const int ServerFileNotFoundExceptionErrorCode = -2147024894; // kept for compatibility with logs
        private readonly Func<HttpClient> _httpClientFactory;

        public Office365StorageWrapper()
            : this(AuthenticationHelper.EnsureClient)
        {
        }

        internal Office365StorageWrapper(Func<HttpClient> httpClientFactory)
        {
            if (httpClientFactory == null) throw new ArgumentNullException(nameof(httpClientFactory));
            _httpClientFactory = httpClientFactory;
            Logger = new LoggerNullObject();
        }

        public ILogger Logger { get; set; }

        // ======================
        // Public API (unchanged)
        // ======================

        public List<string> GetAllFiles(string listName)
        {
            try
            {
                using (var http = _httpClientFactory())
                {
                    var ids = ResolveIds(http, listName);
                    var items = ListChildren(http, ids.DriveId, null, select: "id,name,file", filter: null);
                    return items.Where(i => i["file"] != null).Select(i => (string)i["name"]).ToList();
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(1, ex, "The process was unable to get the files from {0}. Error: {1}", listName, ex.Message);
                return new List<string>();
            }
        }

        public IList<string> GetFilenamesByFileNameStartText(string libraryName, string fileNameStartText)
        {
            var fileNames = new List<string>();
            using (var http = _httpClientFactory())
            {
                try
                {
                    var ids = ResolveIds(http, libraryName);
                    // $filter=startswith(name,'prefix') on children
                    string filter = "startswith(name,'" + EscapeODataLiteral(fileNameStartText) + "')";
                    var items = ListChildren(http, ids.DriveId, null, select: "id,name,file", filter: filter);
                    foreach (var i in items.Where(x => x["file"] != null))
                        fileNames.Add((string)i["name"]);
                }
                catch (Exception ex)
                {
                    Logger.LogInformation("GetFilenamesByFileNameStartText failed for library '{0}', prefix '{1}'. Error: {2}",
                        libraryName, fileNameStartText, ex.Message);
                    throw;
                }
            }
            return fileNames;
        }

        public Dictionary<string, byte[]> GetFilesByFileNameStartText(string libraryName, string fileNameStartText)
        {
            var dict = new Dictionary<string, byte[]>();
            using (var http = _httpClientFactory())
            {
                try
                {
                    var ids = ResolveIds(http, libraryName);
                    string filter = "startswith(name,'" + EscapeODataLiteral(fileNameStartText) + "')";
                    var items = ListChildren(http, ids.DriveId, null, select: "id,name,file", filter: filter);
                    foreach (var i in items.Where(x => x["file"] != null))
                    {
                        var name = (string)i["name"];
                        var bytes = DownloadByPath(http, ids.DriveId, new[] { name });
                        dict[name] = bytes;
                    }
                }
                catch (Exception ex)
                {
                    Logger.LogInformation("GetFilesByFileNameStartText failed for library '{0}', prefix '{1}'. Error: {2}",
                        libraryName, fileNameStartText, ex.Message);
                    return new Dictionary<string, byte[]>();
                }
            }
            return dict;
        }

        public int GetFileVersionCount(string fileName, string listName)
        {
            using (var http = _httpClientFactory())
            {
                var ids = ResolveIds(http, listName);
                var versions = GetItemVersions(http, ids.DriveId, new[] { fileName });
                return versions;
            }
        }

        public DateTime GetFileTimestamp(string fileName, string listName)
        {
            using (var http = _httpClientFactory())
            {
                var ids = ResolveIds(http, listName);
                var meta = GetItemMetadata(http, ids.DriveId, new[] { fileName }, select: "lastModifiedDateTime");
                var tsStr = (string)meta["lastModifiedDateTime"];
                return DateTime.Parse(tsStr, CultureInfo.InvariantCulture).ToUniversalTime();
            }
        }

        public bool DoesFileExist(string listName, string folderName, string fileName)
        {
            using (var http = _httpClientFactory())
            {
                var ids = ResolveIds(http, listName);
                return ItemExistsByPath(http, ids.DriveId, new[] { folderName, fileName });
            }
        }

        public bool DoesFileExist(string listName, string fileName)
        {
            using (var http = _httpClientFactory())
            {
                var ids = ResolveIds(http, listName);
                return ItemExistsByPath(http, ids.DriveId, new[] { fileName });
            }
        }

        public bool DoesFolderExist(string listName, string folderName)
        {
            using (var http = _httpClientFactory())
            {
                var ids = ResolveIds(http, listName);
                var j = GetItemMetadata(http, ids.DriveId, new[] { folderName }, select: "id,folder");
                return j != null && j["folder"] != null;
            }
        }

        public bool DoesLibraryExist(string libraryName)
        {
            // In original CSOM, this tested whether a *library* exists by title.
            using (var http = _httpClientFactory())
            {
                var siteId = ResolveSiteId(http);
                var drive = FindDriveByName(http, siteId, libraryName);
                return drive != null;
            }
        }

        public byte[] GetFileContents(string fileName, string listName)
        {
            using (var http = _httpClientFactory())
            {
                try
                {
                    var ids = ResolveIds(http, listName);
                    return DownloadByPath(http, ids.DriveId, new[] { fileName });
                }
                catch (Exception)
                {
                    Logger.LogError(1, "Unable to get file contents of {0} from {1}.", fileName, listName);
                    throw;
                }
            }
        }

        public byte[] GetFileContents(string listName, string folderName, string fileName)
        {
            using (var http = _httpClientFactory())
            {
                try
                {
                    var ids = ResolveIds(http, listName);
                    return DownloadByPath(http, ids.DriveId, new[] { folderName, fileName });
                }
                catch (Exception)
                {
                    Logger.LogInformation("Unable to get file contents of {0} from {1} folder in {2}.", fileName, folderName, listName);
                    throw;
                }
            }
        }

        public void MoveFile(string originalFileName, string sourceListName, string targetListName)
        {
            using (var http = _httpClientFactory())
            {
                var src = ResolveIds(http, sourceListName);
                var dst = ResolveIds(http, targetListName);

                var itemId = TryGetItemIdByPath(http, src.DriveId, new[] { originalFileName });
                if (itemId == null) return;

                MoveItem(http, src.DriveId, itemId, dst.DriveId, null /*root*/, originalFileName);
            }
        }

        public void MoveFileWithRename(string originalFileName, string sourceListName, string targetListName, string newFileName)
        {
            using (var http = _httpClientFactory())
            {
                var src = ResolveIds(http, sourceListName);
                var dst = ResolveIds(http, targetListName);

                var itemId = TryGetItemIdByPath(http, src.DriveId, new[] { originalFileName });
                if (itemId == null) return;

                MoveItem(http, src.DriveId, itemId, dst.DriveId, null /*root*/, newFileName);
            }
        }

        public void UploadFile(string fileName, byte[] content, string targetListName)
        {
            using (var http = _httpClientFactory())
            {
                var ids = ResolveIds(http, targetListName);
                UploadByPath(http, ids.DriveId, new[] { fileName }, content);
            }
        }

        public void UpsertFile(string fileName, byte[] content, string targetListName)
        {
            using (var http = _httpClientFactory())
            {
                var ids = ResolveIds(http, targetListName);
                UploadByPath(http, ids.DriveId, new[] { fileName }, content, overwrite: true);
            }
        }

        public void UploadFileToFolderWithOverwrite(string rootFolder, string childFolder, byte[] content, string fileName)
        {
            using (var http = _httpClientFactory())
            {
                var ids = ResolveIds(http, rootFolder);
                EnsureFolderPath(http, ids.DriveId, childFolder);
                UploadByPath(http, ids.DriveId, new[] { childFolder, fileName }, content, overwrite: true);
            }
        }

        public void UploadFileToFolderWithOverwrite(string rootFolder, string childFolder, string childOfChildFolder, byte[] content, string fileName)
        {
            using (var http = _httpClientFactory())
            {
                var ids = ResolveIds(http, rootFolder);
                EnsureFolderPath(http, ids.DriveId, childFolder, childOfChildFolder);
                UploadByPath(http, ids.DriveId, new[] { childFolder, childOfChildFolder, fileName }, content, overwrite: true);
            }
        }

        public void UploadFilesToFolderWithOverwrite(string rootFolder, string childFolder, IReadOnlyCollection<Office365FileInfo> files)
        {
            using (var http = _httpClientFactory())
            {
                var ids = ResolveIds(http, rootFolder);
                EnsureFolderPath(http, ids.DriveId, childFolder);

                foreach (var f in files)
                {
                    UploadByPath(http, ids.DriveId, new[] { childFolder, f.FileName }, f.Content ?? new byte[0], overwrite: true);
                }
            }
        }

        public void UploadFileWithOverwrite(string fileName, byte[] content, string targetListName)
        {
            using (var http = _httpClientFactory())
            {
                var ids = ResolveIds(http, targetListName);
                UploadByPath(http, ids.DriveId, new[] { fileName }, content, overwrite: true);
                Logger.LogInformation("Successfully uploaded {0} to {1}.", fileName, targetListName);
            }
        }

        public void UploadFile(string fileName, byte[] content, string listName, string folderName)
        {
            using (var http = _httpClientFactory())
            {
                var ids = ResolveIds(http, listName);
                EnsureFolderPath(http, ids.DriveId, folderName);
                UploadByPath(http, ids.DriveId, new[] { folderName, fileName }, content);
            }
        }

        public void DeleteFile(string fileName, string listName)
        {
            using (var http = _httpClientFactory())
            {
                var ids = ResolveIds(http, listName);
                DeleteByPath(http, ids.DriveId, new[] { fileName });
            }
        }

        public void DeleteFile(string fileName, string listName, string folderName)
        {
            using (var http = _httpClientFactory())
            {
                try
                {
                    var ids = ResolveIds(http, listName);
                    DeleteByPath(http, ids.DriveId, new[] { folderName, fileName });
                }
                catch (InvalidOperationException) { }
                catch (Exception ex)
                {
                    Logger.LogError(1, ex, "Unable to delete {0} from {1}/{2}.", fileName, listName, folderName);
                    throw;
                }
            }
        }

        public void RemoveOldFilesFromFolder(string listName, int offsetFromToday)
        {
            var cutoff = DateTime.UtcNow.Date.AddDays(-offsetFromToday);

            using (var http = _httpClientFactory())
            {
                var ids = ResolveIds(http, listName);

                // BFS through folders under root; delete files older than cutoff
                var rootId = "root";
                var folders = new Queue<string>();
                folders.Enqueue(rootId);

                while (folders.Count > 0)
                {
                    var parent = folders.Dequeue();

                    // list children: id,name,folder,lastModifiedDateTime
                    var children = ListChildren(http, ids.DriveId, parent == "root" ? null : parent,
                        select: "id,name,folder,file,lastModifiedDateTime", filter: null);

                    foreach (var child in children)
                    {
                        if (child["folder"] != null)
                        {
                            folders.Enqueue((string)child["id"]);
                            continue;
                        }

                        if (child["file"] != null)
                        {
                            var lm = (string)child["lastModifiedDateTime"];
                            DateTime lastMod;
                            if (DateTime.TryParse(lm, out lastMod))
                            {
                                if (lastMod.ToUniversalTime() <= cutoff)
                                {
                                    var id = (string)child["id"];
                                    DeleteById(http, ids.DriveId, id);
                                }
                            }
                        }
                    }
                }
            }
        }

        public void RenameFile(string sourceFileName, string targetFileName, string listName, string folderName)
        {
            using (var http = _httpClientFactory())
            {
                try
                {
                    var ids = ResolveIds(http, listName);
                    var itemId = TryGetItemIdByPath(http, ids.DriveId,
                        string.IsNullOrEmpty(folderName) ? new[] { sourceFileName } : new[] { folderName, sourceFileName });
                    if (itemId == null) throw new FileNotFoundException("File " + sourceFileName + " not found.");

                    RenameItem(http, ids.DriveId, itemId, targetFileName);
                }
                catch (Exception ex)
                {
                    Logger.LogInformation("Unable to rename {0} to {1}: {2}", sourceFileName, targetFileName, ex.Message);
                    throw;
                }
            }
        }

        public void RenameFile(string sourceFileName, string targetFileName, string listName)
        {
            RenameFile(sourceFileName, targetFileName, listName, string.Empty);
        }

        public void CreateLibrary(string libraryName)
        {
            using (var http = _httpClientFactory())
            {
                try
                {
                    var siteId = ResolveSiteId(http);

                    // STEP 1 — Check if the document library already exists
                    using (var checkResp = http.GetAsync(
                        $"https://graph.microsoft.com/v1.0/sites/{siteId}/lists?$select=id,displayName").Result)
                    {
                        checkResp.EnsureSuccessStatusCode();
                        var json = JObject.Parse(checkResp.Content.ReadAsStringAsync().Result);

                        var exists = json["value"]
                            .Any(v => string.Equals(
                                (string)v["displayName"],
                                libraryName,
                                StringComparison.OrdinalIgnoreCase));

                        if (exists)
                        {
                            // Already exists — OK, return silently
                            return;
                        }
                    }

                    // STEP 2 — Create the document library
                    var body = new JObject
                    {
                        ["displayName"] = libraryName,
                        ["list"] = new JObject
                        {
                            ["template"] = "documentLibrary"
                        }
                    };


                    var content = new StringContent(body.ToString(), Encoding.UTF8, "application/json");
                    using (var resp = http.PostAsync(
                        $"https://graph.microsoft.com/v1.0/sites/{siteId}/lists", content).Result)
                    {
                        resp.EnsureSuccessStatusCode();
                    }
                }
                catch (Exception ex)
                {
                    Logger.LogInformation("Unable to create document library {0}, exception: {1}", libraryName, ex.Message);
                    throw;
                }
            }
        }

        public void CreateFolder(string listName, string folderName)
        {
            using (var http = _httpClientFactory())
            {
                try
                {
                    var ids = ResolveIds(http, listName);
                    EnsureFolderPath(http, ids.DriveId, folderName);
                }
                catch (Exception ex)
                {
                    Logger.LogInformation("Unable to create folder {0} under library {1}. Error: {2}",
                        folderName, listName, ex.Message);
                    throw;
                }
            }
        }

        public void CreateFolder(string rootListName, string listName, string folderName)
        {
            using (var http = _httpClientFactory())
            {
                try
                {
                    var ids = ResolveIds(http, rootListName);
                    // Ensure `listName` exists as a child under root, then create sub-folder `folderName`
                    var parentId = EnsureFolder(http, ids.DriveId, null, listName);
                    EnsureFolder(http, ids.DriveId, parentId, folderName);
                }
                catch (Exception ex)
                {
                    Logger.LogInformation("Unable to create folder {0} under folder {1}. Error: {2}",
                        folderName, listName, ex.Message);
                    throw;
                }
            }
        }

        // ======================
        // Internal Graph helpers
        // ======================

        private struct SiteDriveIds
        {
            public string SiteId;
            public string DriveId;
        }

        private static SiteDriveIds ResolveIds(HttpClient http, string libraryDisplayName)
        {
            var siteId = ResolveSiteId(http);
            var drive = FindDriveByName(http, siteId, libraryDisplayName);
            if (drive == null)
                throw new InvalidOperationException("Document library not found: " + libraryDisplayName);

            var ids = new SiteDriveIds();
            ids.SiteId = siteId;
            ids.DriveId = (string)drive["id"];
            return ids;
        }
        private static string ResolveSiteId(HttpClient http)
        {
            string siteUrl = ConfigurationManager.AppSettings["ida:Resource"];
            if (string.IsNullOrWhiteSpace(siteUrl))
                throw new InvalidOperationException("AppSetting 'ida:Resource' must be a full SharePoint site URL.");

            if (!Uri.TryCreate(siteUrl, UriKind.Absolute, out var uri))
                throw new InvalidOperationException("Invalid ida:Resource URL: " + siteUrl);

            var host = uri.Host;
            var path = uri.AbsolutePath; // includes leading '/'

            using (var resp = http.GetAsync(
                $"https://graph.microsoft.com/v1.0/sites/{host}:{path}").Result)
            {
                resp.EnsureSuccessStatusCode();
                var json = JObject.Parse(resp.Content.ReadAsStringAsync().Result);
                return (string)json["id"];
            }
        }
       
        private static JObject FindDriveByName(HttpClient http, string siteId, string driveDisplayName)
        {
            // (A) Page through /drives
            string url = "https://graph.microsoft.com/v1.0/sites/" + siteId + "/drives?$select=id,name,webUrl,driveType";
            var drives = new List<JObject>();

            while (!string.IsNullOrEmpty(url))
            {
                using (var resp = http.GetAsync(url).Result)
                {
                    resp.EnsureSuccessStatusCode();
                    var j = JObject.Parse(resp.Content.ReadAsStringAsync().Result);

                    var page = j["value"]?
                        .Where(d => string.Equals((string)d["driveType"], "documentLibrary", StringComparison.OrdinalIgnoreCase))
                        .Select(d => (JObject)d) ?? Enumerable.Empty<JObject>();

                    drives.AddRange(page);
                    url = (string)j["@odata.nextLink"];
                }
            }

            // 1) Exact name match
            var exact = drives.FirstOrDefault(d =>
                string.Equals((string)d["name"], driveDisplayName, StringComparison.OrdinalIgnoreCase));
            if (exact != null) return exact;

            // 2) webUrl heuristic (covers minor rename differences)
            var urlHit = drives.FirstOrDefault(d =>
                ((string)d["webUrl"])?.IndexOf("/" + driveDisplayName + "/", StringComparison.OrdinalIgnoreCase) >= 0);
            if (urlHit != null) return urlHit;

            // (B) Fallback: Lists -> Drive (string template "documentLibrary"), with paging
            string listsUrl = "https://graph.microsoft.com/v1.0/sites/" + siteId + "/lists?$select=id,name,displayName,list,webUrl";
            string matchedListId = null;

            while (!string.IsNullOrEmpty(listsUrl) && matchedListId == null)
            {
                using (var resp = http.GetAsync(listsUrl).Result)
                {
                    resp.EnsureSuccessStatusCode();
                    var j = JObject.Parse(resp.Content.ReadAsStringAsync().Result);

                    var docLibs = j["value"]?
                        .Where(l => string.Equals((string)l["list"]?["template"], "documentLibrary", StringComparison.OrdinalIgnoreCase))
                        .Select(l => (JObject)l) ?? Enumerable.Empty<JObject>();

                    var match = docLibs.FirstOrDefault(l =>
                        string.Equals((string)l["displayName"], driveDisplayName, StringComparison.OrdinalIgnoreCase) ||
                        string.Equals((string)l["name"], driveDisplayName, StringComparison.OrdinalIgnoreCase));

                    if (match != null)
                        matchedListId = (string)match["id"];

                    listsUrl = (string)j["@odata.nextLink"]; // page lists too
                }
            }

            if (!string.IsNullOrEmpty(matchedListId))
            {
                using (var resp = http.GetAsync("https://graph.microsoft.com/v1.0/sites/" + siteId + "/lists/" + matchedListId + "/drive").Result)
                {
                    resp.EnsureSuccessStatusCode();
                    var driveForListJson = JObject.Parse(resp.Content.ReadAsStringAsync().Result);
                    // Return the resolved drive object (contains id, webUrl, etc.)
                    return driveForListJson;
                }
            }

            // Not found
            return null;
        }

        private static string EscapeODataLiteral(string value)
        {
            return (value ?? string.Empty).Replace("'", "''");
        }

        private static string CombinePath(params string[] segments)
        {
            return string.Join("/", segments.Where(s => !string.IsNullOrEmpty(s)).Select(s => Uri.EscapeDataString(s)));
        }

        private static IList<JObject> ListChildren(HttpClient http, string driveId, string parentItemIdOrNullForRoot, string select, string filter)
        {
            var results = new List<JObject>();
            string baseUrl = parentItemIdOrNullForRoot == null
                ? "https://graph.microsoft.com/v1.0/drives/" + driveId + "/root/children"
                : "https://graph.microsoft.com/v1.0/drives/" + driveId + "/items/" + parentItemIdOrNullForRoot + "/children";

            var url = baseUrl;
            var qp = new List<string>();
            if (!string.IsNullOrEmpty(select)) qp.Add("$select=" + select);
            if (!string.IsNullOrEmpty(filter)) qp.Add("$filter=" + filter);
            if (qp.Count > 0) url = baseUrl + "?" + string.Join("&", qp);

            while (!string.IsNullOrEmpty(url))
            {
                using (var resp = http.GetAsync(url).Result)
                {
                    resp.EnsureSuccessStatusCode();
                    var j = JObject.Parse(resp.Content.ReadAsStringAsync().Result);
                    foreach (var x in j["value"]) results.Add((JObject)x);
                    url = (string)j["@odata.nextLink"];
                }
            }
            return results;
        }

        private static string TryGetItemIdByPath(HttpClient http, string driveId, string[] pathSegments)
        {
            var path = CombinePath(pathSegments);
            var url = "https://graph.microsoft.com/v1.0/drives/" + driveId + "/root:/" + path;

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

        private static JObject GetItemMetadata(HttpClient http, string driveId, string[] pathSegments, string select)
        {
            var path = CombinePath(pathSegments);
            var url = "https://graph.microsoft.com/v1.0/drives/" + driveId + "/root:/" + path;
            if (!string.IsNullOrEmpty(select)) url += "?$select=" + select;

            using (var resp = http.GetAsync(url).Result)
            {
                if (resp.IsSuccessStatusCode)
                {
                    var j = JObject.Parse(resp.Content.ReadAsStringAsync().Result);
                    return j;
                }
                if ((int)resp.StatusCode == 404) return null;

                var body = resp.Content.ReadAsStringAsync().Result;
                throw new InvalidOperationException("GetItemMetadata failed: " + (int)resp.StatusCode + " " + resp.ReasonPhrase + " Body: " + body);
            }
        }

        private static bool ItemExistsByPath(HttpClient http, string driveId, string[] pathSegments)
        {
            return TryGetItemIdByPath(http, driveId, pathSegments) != null;
        }

        private static void EnsureFolderPath(HttpClient http, string driveId, params string[] segments)
        {
            if (segments == null || segments.Length == 0) return;

            string parentId = null;
            for (int i = 0; i < segments.Length; i++)
            {
                var name = segments[i];
                parentId = EnsureFolder(http, driveId, parentId, name);
            }
        }

        private static string EnsureFolder(HttpClient http, string driveId, string parentItemIdOrNullForRoot, string folderName)
        {
            // Exists?
            if (parentItemIdOrNullForRoot == null)
            {
                var existing = GetItemMetadata(http, driveId, new[] { folderName }, "id,folder");
                if (existing != null && existing["folder"] != null) return (string)existing["id"];
            }
            else
            {
                var children = ListChildren(http, driveId, parentItemIdOrNullForRoot, select: "id,name,folder", filter: null);
                var match = children.FirstOrDefault(x =>
                    x["folder"] != null &&
                    string.Equals((string)x["name"], folderName, StringComparison.OrdinalIgnoreCase));
                if (match != null) return (string)match["id"];
            }

            // Create
            var body = new JObject();
            body["name"] = folderName;
            body["folder"] = new JObject();
            body["@microsoft.graph.conflictBehavior"] = "replace";

            string url = parentItemIdOrNullForRoot == null
                ? "https://graph.microsoft.com/v1.0/drives/" + driveId + "/root/children"
                : "https://graph.microsoft.com/v1.0/drives/" + driveId + "/items/" + parentItemIdOrNullForRoot + "/children";

            using (var content = new StringContent(body.ToString(), Encoding.UTF8, "application/json"))
            using (var resp = http.PostAsync(url, content).Result)
            {
                resp.EnsureSuccessStatusCode();
                var j = JObject.Parse(resp.Content.ReadAsStringAsync().Result);
                return (string)j["id"];
            }
        }

        private static void UploadByPath(HttpClient http, string driveId, string[] pathSegments, byte[] content, bool overwrite = true)
        {
            var path = CombinePath(pathSegments);
            var url = "https://graph.microsoft.com/v1.0/drives/" + driveId + "/root:/" + path + ":/content";
            if (!overwrite) url += "?@microsoft.graph.conflictBehavior=fail";

            using (var bytes = new ByteArrayContent(content ?? new byte[0]))
            {
                bytes.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
                using (var resp = http.PutAsync(url, bytes).Result)
                {
                    resp.EnsureSuccessStatusCode();
                }
            }
        }

        private static byte[] DownloadByPath(HttpClient http, string driveId, string[] pathSegments)
        {
            var path = CombinePath(pathSegments);
            var url = "https://graph.microsoft.com/v1.0/drives/" + driveId + "/root:/" + path + ":/content";

            using (var resp = http.GetAsync(url).Result)
            {
                if (!resp.IsSuccessStatusCode)
                {
                    if ((int)resp.StatusCode == 404)
                        throw new FileNotFoundException("Item not found at path: " + string.Join("/", pathSegments));
                    var body = resp.Content.ReadAsStringAsync().Result;
                    throw new InvalidOperationException("Download failed: " + (int)resp.StatusCode + " " + resp.ReasonPhrase + " Body: " + body);
                }
                return resp.Content.ReadAsByteArrayAsync().Result;
            }
        }

        private static void DeleteByPath(HttpClient http, string driveId, string[] pathSegments)
        {
            var id = TryGetItemIdByPath(http, driveId, pathSegments);
            if (id == null) return;
            DeleteById(http, driveId, id);
        }

        private static void DeleteById(HttpClient http, string driveId, string itemId)
        {
            using (var resp = http.DeleteAsync("https://graph.microsoft.com/v1.0/drives/" + driveId + "/items/" + itemId).Result)
            {
                if (!resp.IsSuccessStatusCode && (int)resp.StatusCode != 204)
                {
                    var body = resp.Content.ReadAsStringAsync().Result;
                    throw new InvalidOperationException("Delete failed: " + (int)resp.StatusCode + " " + resp.ReasonPhrase + " Body: " + body);
                }
            }
        }

        private static int GetItemVersions(HttpClient http, string driveId, string[] pathSegments)
        {
            var path = CombinePath(pathSegments);
            var url = "https://graph.microsoft.com/v1.0/drives/" + driveId + "/root:/" + path + ":/versions?$top=200";

            int count = 0;
            while (!string.IsNullOrEmpty(url))
            {
                using (var resp = http.GetAsync(url).Result)
                {
                    resp.EnsureSuccessStatusCode();
                    var j = JObject.Parse(resp.Content.ReadAsStringAsync().Result);
                    count += j["value"].Count();
                    url = (string)j["@odata.nextLink"];
                }
            }
            return count;
        }


        private static void MoveItem(HttpClient http, string srcDriveId, string itemId, string dstDriveId, string dstParentIdOrNullForRoot, string newNameOrNull)
        {
            // Resolve destination parent id (root if null)
            if (string.IsNullOrEmpty(dstParentIdOrNullForRoot))
            {
                using (var rootResp = http.GetAsync($"https://graph.microsoft.com/v1.0/drives/{dstDriveId}/root?$select=id").Result)
                {
                    rootResp.EnsureSuccessStatusCode();
                    var rootJson = JObject.Parse(rootResp.Content.ReadAsStringAsync().Result);
                    dstParentIdOrNullForRoot = (string)rootJson["id"];
                    if (string.IsNullOrEmpty(dstParentIdOrNullForRoot))
                        throw new InvalidOperationException("Failed to resolve destination root id.");
                }
            }

            var parentRef = new JObject
            {
                ["driveId"] = dstDriveId,
                ["id"] = dstParentIdOrNullForRoot
            };

            // If drives differ, do a COPY then PERMANENT DELETE (bypass recycle bin)
            if (!string.Equals(srcDriveId, dstDriveId, StringComparison.OrdinalIgnoreCase))
            {
                var copyBody = new JObject
                {
                    ["parentReference"] = parentRef
                };
                if (!string.IsNullOrEmpty(newNameOrNull))
                    copyBody["name"] = newNameOrNull;

                var copyUrl = $"https://graph.microsoft.com/v1.0/drives/{srcDriveId}/items/{itemId}/copy";

                using (var content = new StringContent(copyBody.ToString(), Encoding.UTF8, "application/json"))
                using (var copyResp = http.PostAsync(copyUrl, content).Result)
                {
                    copyResp.EnsureSuccessStatusCode();
                    // TODO: Poll the Location header until the copy completes (recommended).
                    System.Threading.Thread.Sleep(TimeSpan.FromSeconds(2)); // basic placeholder
                }

                // Permanently delete source item after copy (doesn't go to recycle bin)
                var permanentDeleteUrl = $"https://graph.microsoft.com/v1.0/drives/{srcDriveId}/items/{itemId}/permanentDelete";
                using (var permDelResp = http.PostAsync(permanentDeleteUrl, content: null).Result)
                {
                    // 204 No Content expected on success
                    if (!permDelResp.IsSuccessStatusCode && (int)permDelResp.StatusCode != 204)
                    {
                        var bodyText = permDelResp.Content?.ReadAsStringAsync().Result;
                        throw new InvalidOperationException(
                            $"Permanent delete after copy failed: {(int)permDelResp.StatusCode} {permDelResp.ReasonPhrase}. Body: {bodyText}");
                    }
                }

                return;
            }

            // Same drive: perform MOVE (fast metadata change)
            var moveBody = new JObject
            {
                ["parentReference"] = parentRef
            };
            if (!string.IsNullOrEmpty(newNameOrNull))
                moveBody["name"] = newNameOrNull;

            var moveUrl = $"https://graph.microsoft.com/v1.0/drives/{srcDriveId}/items/{itemId}/move";
            using (var content = new StringContent(moveBody.ToString(), Encoding.UTF8, "application/json"))
            using (var resp = http.PostAsync(moveUrl, content).Result)
            {
                resp.EnsureSuccessStatusCode();
            }
        }



        //private static void MoveItem(HttpClient http, string srcDriveId, string itemId, string dstDriveId, string dstParentIdOrNullForRoot, string newNameOrNull)
        //{
        //    // Resolve destination parent id (root if null)
        //    if (string.IsNullOrEmpty(dstParentIdOrNullForRoot))
        //    {
        //        using (var rootResp = http.GetAsync($"https://graph.microsoft.com/v1.0/drives/{dstDriveId}/root?$select=id").Result)
        //        {
        //            rootResp.EnsureSuccessStatusCode();
        //            var rootJson = JObject.Parse(rootResp.Content.ReadAsStringAsync().Result);
        //            dstParentIdOrNullForRoot = (string)rootJson["id"];
        //            if (string.IsNullOrEmpty(dstParentIdOrNullForRoot))
        //                throw new InvalidOperationException("Failed to resolve destination root id.");
        //        }
        //    }

        //    var parentRef = new JObject
        //    {
        //        ["driveId"] = dstDriveId,
        //        ["id"] = dstParentIdOrNullForRoot
        //    };

        //    // If drives differ, do a COPY then DELETE (Graph move often doesn't support cross-drive)
        //    if (!string.Equals(srcDriveId, dstDriveId, StringComparison.OrdinalIgnoreCase))
        //    {
        //        var copyBody = new JObject
        //        {
        //            ["parentReference"] = parentRef
        //        };
        //        if (!string.IsNullOrEmpty(newNameOrNull))
        //            copyBody["name"] = newNameOrNull;

        //        var copyUrl = $"https://graph.microsoft.com/v1.0/drives/{srcDriveId}/items/{itemId}/copy";

        //        using (var content = new StringContent(copyBody.ToString(), Encoding.UTF8, "application/json"))
        //        using (var copyResp = http.PostAsync(copyUrl, content).Result)
        //        {
        //            copyResp.EnsureSuccessStatusCode();

        //            // Copy returns 202 Accepted with a Location header to poll. For simplicity,
        //            // you can add a small delay or implement proper polling here.
        //            // Example (basic): wait briefly to allow copy to complete.
        //            System.Threading.Thread.Sleep(TimeSpan.FromSeconds(2));
        //        }

        //        // Delete source item after copy
        //        var deleteUrl = $"https://graph.microsoft.com/v1.0/drives/{srcDriveId}/items/{itemId}";
        //        using (var delResp = http.DeleteAsync(deleteUrl).Result)
        //        {
        //            // 204 No Content expected
        //            if (!delResp.IsSuccessStatusCode && (int)delResp.StatusCode != 204)
        //            {
        //                var bodyText = delResp.Content.ReadAsStringAsync().Result;
        //                throw new InvalidOperationException($"Delete after copy failed: {(int)delResp.StatusCode} {delResp.ReasonPhrase}. Body: {bodyText}");
        //            }
        //        }

        //        return;
        //    }

        //    // Same drive: perform MOVE
        //    var moveBody = new JObject
        //    {
        //        ["parentReference"] = parentRef
        //    };
        //    if (!string.IsNullOrEmpty(newNameOrNull))
        //        moveBody["name"] = newNameOrNull;

        //    var moveUrl = $"https://graph.microsoft.com/v1.0/drives/{srcDriveId}/items/{itemId}/move";
        //    using (var content = new StringContent(moveBody.ToString(), Encoding.UTF8, "application/json"))
        //    using (var resp = http.PostAsync(moveUrl, content).Result)
        //    {
        //        resp.EnsureSuccessStatusCode();
        //    }
        //}


        private static void RenameItem(HttpClient http, string driveId, string itemId, string newName)
        {
            var body = new JObject();
            body["name"] = newName;

            var url = "https://graph.microsoft.com/v1.0/drives/" + driveId + "/items/" + itemId;

            using (var content = new StringContent(body.ToString(), Encoding.UTF8, "application/json"))
            {
                var method = new HttpMethod("PATCH");
                using (var req = new HttpRequestMessage(method, url) { Content = content })
                using (var resp = http.SendAsync(req).Result)
                {
                    resp.EnsureSuccessStatusCode();
                }
            }
        }
    }
}
