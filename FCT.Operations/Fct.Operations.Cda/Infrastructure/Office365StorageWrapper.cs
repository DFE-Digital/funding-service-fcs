namespace FCT.Operations.Cda.Infrastructure
{
    using Newtonsoft.Json.Linq;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;

    public class Office365StorageWrapper : IOffice365StorageWrapper
    {
        // Kept for logging parity with previous CSOM code (not used directly now).
        private const int ServerFileNotFoundExceptionErrorCode = -2147024894;

        private readonly IFcsConfiguration _configurationRoot;
        private readonly ILogger _logger;
        private readonly IAuthenticationHelper _authenticationHelper;

        public Office365StorageWrapper(IFcsConfiguration configuration, ILogger logger, IAuthenticationHelper authenticationHelper)
        {
            _logger = logger;
            _authenticationHelper = authenticationHelper;
            _configurationRoot = configuration;
        }

        // ======================
        // Public API (unchanged)
        // ======================

        public List<string> GetAllFiles(string listName)
        {
            try
            {
                using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
                {
                    var ids = ResolveIds(http, listName);
                    var items = ListChildren(http, ids.DriveId, null, "id,name,file", null);
                    return items.Where(i => i["file"] != null).Select(i => (string)i["name"]).ToList();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(1, ex, "The process was unable to get the files from {0}. Error message {1}", listName, ex.Message);
                return new List<string>();
            }
        }

        public IList<string> GetFilenamesByFileNameStartText(string libraryName, string fileNameStartText)
        {
            var fileNames = new List<string>();
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                try
                {
                    var ids = ResolveIds(http, libraryName);
                    var filter = "startswith(name,'" + EscapeODataLiteral(fileNameStartText) + "')";
                    var items = ListChildren(http, ids.DriveId, null, "id,name,file", filter);
                    foreach (var item in items.Where(x => x["file"] != null))
                        fileNames.Add((string)item["name"]);
                }
                catch (Exception ex)
                {
                    _logger.LogInformation("The process was unable to execute method GetFilenamesByFileNameStartText for the library '{0}' and provided partial filename '{1}'. Error Message: {2}", libraryName, fileNameStartText, ex.Message);
                    throw;
                }
            }
            return fileNames;
        }

        public Dictionary<string, byte[]> GetFilesByFileNameStartText(string libraryName, string fileNameStartText)
        {
            var dict = new Dictionary<string, byte[]>();
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                try
                {
                    var ids = ResolveIds(http, libraryName);
                    var filter = "startswith(name,'" + EscapeODataLiteral(fileNameStartText) + "')";
                    var items = ListChildren(http, ids.DriveId, null, "id,name,file", filter);
                    foreach (var item in items.Where(x => x["file"] != null))
                    {
                        var name = (string)item["name"];
                        var bytes = DownloadByPath(http, ids.DriveId, new[] { name });
                        dict[name] = bytes;
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogInformation("The process was unable to execute method GetFilesByFileNameStartText for the library '{0}' and provided partial filename '{1}'. Error Message: {2}", libraryName, fileNameStartText, ex.Message);
                    return new Dictionary<string, byte[]>();
                }
            }
            return dict;
        }

        public int GetFileVersionCount(string fileName, string listName)
        {
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                var ids = ResolveIds(http, listName);
                return GetItemVersions(http, ids.DriveId, new[] { fileName });
            }
        }

        public DateTime GetFileTimestamp(string fileName, string listName)
        {
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                var ids = ResolveIds(http, listName);
                var meta = GetItemMetadata(http, ids.DriveId, new[] { fileName }, "lastModifiedDateTime");
                var tsStr = meta != null ? (string)meta["lastModifiedDateTime"] : null;
                return DateTime.Parse(tsStr).ToUniversalTime();
            }
        }

        public bool DoesFileExist(string listName, string folderName, string fileName)
        {
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                var ids = ResolveIds(http, listName);
                return ItemExistsByPath(http, ids.DriveId, new[] { folderName, fileName });
            }
        }

        public bool DoesFileExist(string listName, string fileName)
        {
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                var ids = ResolveIds(http, listName);
                return ItemExistsByPath(http, ids.DriveId, new[] { fileName });
            }
        }

        public bool DoesFolderExist(string listName, string folderName)
        {
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                var ids = ResolveIds(http, listName);
                var j = GetItemMetadata(http, ids.DriveId, new[] { folderName }, "id,folder");
                return j != null && j["folder"] != null;
            }
        }

        public bool DoesFolderExist(string folderName)
        {
            // In the CSOM version, this checked if a *document library* with that title exists.
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                var siteId = ResolveSiteId(http);
                var drive = FindDriveByName(http, siteId, folderName);
                return drive != null;
            }
        }

        public byte[] GetFileContents(string fileName, string listName)
        {
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                try
                {
                    var ids = ResolveIds(http, listName);
                    return DownloadByPath(http, ids.DriveId, new[] { fileName });
                }
                catch
                {
                    _logger.LogError(1, "The process was unable to get the file contents of {0} from {1} list.", fileName, listName);
                    throw;
                }
            }
        }

        public byte[] GetFileContents(string listName, string folderName, string fileName)
        {
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                try
                {
                    var ids = ResolveIds(http, listName);
                    return DownloadByPath(http, ids.DriveId, new[] { folderName, fileName });
                }
                catch
                {
                    _logger.LogInformation("The process was unable to get the file contents of {0} from {1} folder in {2} list.", fileName, folderName, listName);
                    throw;
                }
            }
        }

        public void MoveFile(string originalFileName, string sourceListName, string targetListName)
        {
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                var src = ResolveIds(http, sourceListName);
                var dst = ResolveIds(http, targetListName);

                var itemId = TryGetItemIdByPath(http, src.DriveId, new[] { originalFileName });
                if (itemId == null) return;

                MoveItem(http, src.DriveId, itemId, dst.DriveId, null, originalFileName);
            }
        }

        public void MoveFileWithRename(string originalFileName, string sourceListName, string targetListName, string newFileName)
        {
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                var src = ResolveIds(http, sourceListName);
                var dst = ResolveIds(http, targetListName);

                var itemId = TryGetItemIdByPath(http, src.DriveId, new[] { originalFileName });
                if (itemId == null) return;

                MoveItem(http, src.DriveId, itemId, dst.DriveId, null, newFileName);
            }
        }

        public void UploadFile(string fileName, byte[] content, string targetListName)
        {
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                var ids = ResolveIds(http, targetListName);
                UploadByPath(http, ids.DriveId, new[] { fileName }, content, true);
            }
        }

        public void UpsertFile(string fileName, byte[] content, string targetListName)
        {
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                var ids = ResolveIds(http, targetListName);
                UploadByPath(http, ids.DriveId, new[] { fileName }, content, true);
            }
        }

        public void UploadFileToFolderWithOverwrite(string rootFolder, string childFolder, byte[] content, string fileName)
        {
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                var ids = ResolveIds(http, rootFolder);
                EnsureFolderPath(http, ids.DriveId, childFolder);
                UploadByPath(http, ids.DriveId, new[] { childFolder, fileName }, content, true);
            }
        }

        public void UploadFileToFolderWithOverwrite(string rootFolder, string childFolder, string childOfChildFolder, byte[] content, string fileName)
        {
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                var ids = ResolveIds(http, rootFolder);
                EnsureFolderPath(http, ids.DriveId, childFolder, childOfChildFolder);
                UploadByPath(http, ids.DriveId, new[] { childFolder, childOfChildFolder, fileName }, content, true);
            }
        }

        public void UploadFilesToFolderWithOverwrite(string rootFolder, string childFolder, IReadOnlyCollection<Office365FileInfo> files)
        {
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                var ids = ResolveIds(http, rootFolder);
                EnsureFolderPath(http, ids.DriveId, childFolder);
                foreach (var f in files)
                {
                    UploadByPath(http, ids.DriveId, new[] { childFolder, f.FileName }, f.Content ?? new byte[0], true);
                }
            }
        }

        public void UploadFileWithOverwrite(string fileName, byte[] content, string targetListName)
        {
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                var ids = ResolveIds(http, targetListName);
                UploadByPath(http, ids.DriveId, new[] { fileName }, content, true);
                _logger.LogInformation("The process successfully loaded the {0} file to the {1} document library.", fileName, targetListName);
            }
        }

        public void UploadFile(string fileName, byte[] content, string listName, string folderName)
        {
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                var ids = ResolveIds(http, listName);
                EnsureFolderPath(http, ids.DriveId, folderName);
                UploadByPath(http, ids.DriveId, new[] { folderName, fileName }, content ?? new byte[0], true);
            }
        }

        public void DeleteFile(string fileName, string listName)
        {
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                var ids = ResolveIds(http, listName);
                DeleteByPath(http, ids.DriveId, new[] { fileName });
            }
        }

        public void DeleteFile(string fileName, string listName, string folderName)
        {
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                try
                {
                    var ids = ResolveIds(http, listName);
                    DeleteByPath(http, ids.DriveId, new[] { folderName, fileName });
                }
                catch (InvalidOperationException)
                {
                    // Ignore: used to swallow when item already absent.
                }
                catch (Exception ex)
                {
                    _logger.LogError(1, ex, "The process was unable to delete the {0} file from the {1}/{2}", fileName, listName, folderName);
                    throw;
                }
            }
        }

        public void RemoveOldFilesFromFolder(string listName, int offsetFromToday)
        {
            var cutoffUtc = DateTime.UtcNow.Date.AddDays(-offsetFromToday);

            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                var ids = ResolveIds(http, listName);

                // BFS across library to delete files older than cutoff
                var queue = new Queue<string>();
                queue.Enqueue(null); // null -> root

                while (queue.Count > 0)
                {
                    var parentId = queue.Dequeue();

                    var children = ListChildren(http, ids.DriveId, parentId, "id,name,folder,file,lastModifiedDateTime", null);

                    foreach (var c in children)
                    {
                        if (c["folder"] != null)
                        {
                            queue.Enqueue((string)c["id"]);
                            continue;
                        }

                        if (c["file"] != null)
                        {
                            var lm = (string)c["lastModifiedDateTime"];
                            DateTime lastMod;
                            if (DateTime.TryParse(lm, out lastMod))
                            {
                                if (lastMod.ToUniversalTime() <= cutoffUtc)
                                {
                                    var id = (string)c["id"];
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
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                try
                {
                    var ids = ResolveIds(http, listName);
                    var path = string.IsNullOrEmpty(folderName)
                        ? new[] { sourceFileName }
                        : new[] { folderName, sourceFileName };

                    var itemId = TryGetItemIdByPath(http, ids.DriveId, path);
                    if (itemId == null) throw new FileNotFoundException("File " + sourceFileName + " does not exist in " + listName);

                    RenameItem(http, ids.DriveId, itemId, targetFileName);
                }
                catch (Exception ex)
                {
                    _logger.LogInformation("The process was unable to rename the {0} file to {1} because of {2}", sourceFileName, targetFileName, ex.Message);
                    throw;
                }
            }
        }

        public void RenameFile(string sourceFileName, string targetFileName, string listName)
        {
            RenameFile(sourceFileName, targetFileName, listName, string.Empty);
        }

        public void CreateFolder(string folderName)
        {
            // Create a new document library (to mirror previous CSOM behavior).
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                try
                {
                    var siteId = ResolveSiteId(http);

                    var body = new JObject();
                    body["name"] = folderName;
                    body["displayName"] = folderName;
                    var listInfo = new JObject();
                    listInfo["template"] = "documentLibrary";
                    body["list"] = listInfo;

                    var content = new StringContent(body.ToString(), Encoding.UTF8, "application/json");
                    using (var resp = http.PostAsync(
                        $"https://graph.microsoft.com/v1.0/sites/{siteId}/lists", content).Result)
                    {
                        resp.EnsureSuccessStatusCode();
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogInformation("The process was unable to create folder {0}, exception: {1}", folderName, ex.Message);
                    throw;
                }
            }
        }

        public void CreateFolder(string listName, string folderName)
        {
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                try
                {
                    var ids = ResolveIds(http, listName);
                    EnsureFolderPath(http, ids.DriveId, folderName);
                }
                catch (Exception ex)
                {
                    _logger.LogInformation("The process was unable to create folder {0} under folder {1}, exception: {2}", folderName, listName, ex.Message);
                    throw;
                }
            }
        }

        public void CreateFolder(string rootListName, string listName, string folderName)
        {
            using (var http = _authenticationHelper.EnsureClient(_configurationRoot["ida:Resource"]))
            {
                try
                {
                    var ids = ResolveIds(http, rootListName);
                    var parentId = EnsureFolder(http, ids.DriveId, null, listName);
                    EnsureFolder(http, ids.DriveId, parentId, folderName);
                }
                catch (Exception ex)
                {
                    _logger.LogInformation("The process was unable to create folder {0} under folder {1}, exception: {2}", folderName, listName, ex.Message);
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

        private SiteDriveIds ResolveIds(HttpClient http, string libraryDisplayName)
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

        private string ResolveSiteId(HttpClient http)
        {
            string siteUrl = _configurationRoot["ida:Resource"];
            if (string.IsNullOrWhiteSpace(siteUrl))
                throw new InvalidOperationException("App setting 'ida:Resource' must be a full SharePoint site URL (e.g., https://xxx.sharepoint.com/sites/fct-dat).");

            Uri uri;
            if (!Uri.TryCreate(siteUrl, UriKind.Absolute, out uri))
                throw new InvalidOperationException("Invalid ida:Resource URL: " + siteUrl);

            var host = uri.Host;
            var path = uri.AbsolutePath; // includes leading '/'

            using (var resp = http.GetAsync("https://graph.microsoft.com/v1.0/sites/" + host + ":" + path).Result)
            {
                resp.EnsureSuccessStatusCode();
                var j = JObject.Parse(resp.Content.ReadAsStringAsync().Result);
                return (string)j["id"];
            }
        }

        /// <summary>
        /// Robust drive resolution:
        ///  - Pages through ALL drives via @odata.nextLink
        ///  - Filters to driveType == "documentLibrary"
        ///  - Tries exact name match, then webUrl heuristic
        ///  - Falls back to Lists -> Drive (string template "documentLibrary"), with paging
        /// Returns the drive JObject (contains "id", "webUrl", etc.), or null if not found.
        /// </summary>
        private JObject FindDriveByName(HttpClient http, string siteId, string driveDisplayName)
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

            // 2) webUrl heuristic (helps with minor title drift)
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
                    return driveForListJson; // contains id, webUrl, etc.
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
                var children = ListChildren(http, driveId, parentItemIdOrNullForRoot, "id,name,folder", null);
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

        private static void UploadByPath(HttpClient http, string driveId, string[] pathSegments, byte[] content, bool overwrite)
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
            var body = new JObject();
            var parentRef = new JObject();
            parentRef["driveId"] = dstDriveId;
            if (!string.IsNullOrEmpty(dstParentIdOrNullForRoot))
                parentRef["id"] = dstParentIdOrNullForRoot;
            body["parentReference"] = parentRef;
            if (!string.IsNullOrEmpty(newNameOrNull))
                body["name"] = newNameOrNull;

            var url = "https://graph.microsoft.com/v1.0/drives/" + srcDriveId + "/items/" + itemId + "/move";

            using (var content = new StringContent(body.ToString(), Encoding.UTF8, "application/json"))
            using (var resp = http.PostAsync(url, content).Result)
            {
                resp.EnsureSuccessStatusCode();
            }
        }

        private static void RenameItem(HttpClient http, string driveId, string itemId, string newName)
        {
            var body = new JObject();
            body["name"] = newName;

            var url = "https://graph.microsoft.com/v1.0/drives/" + driveId + "/items/" + itemId;

            var method = new HttpMethod("PATCH");
            using (var content = new StringContent(body.ToString(), Encoding.UTF8, "application/json"))
            using (var req = new HttpRequestMessage(method, url) { Content = content })
            using (var resp = http.SendAsync(req).Result)
            {
                resp.EnsureSuccessStatusCode();
            }
        }
    }
}
