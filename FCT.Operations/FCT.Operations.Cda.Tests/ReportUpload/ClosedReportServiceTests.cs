namespace FCT.Operations.Cda.Tests.ReportUpload
{
    using Cda.ReportUpload;
    using FCT.Operations.Cda.Dtos;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Newtonsoft.Json.Linq;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Reflection;
    using System.Text;
    using System.Xml.Linq;
    using Microsoft.SharePoint.Client;
    using System.Text.RegularExpressions;

    [TestClass]
    public class ClosedReportServiceTests
    {

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClosedReportService_UploadReportToSharePointIfNecessary_ShouldUploadWhenReportNotAlreadyInFolder()
        {
            // arrange
            const string parentFolderPath = "CDA Reports/Archive";
            const int archivedYear = 2020;
            var closedFolderName = $"_{archivedYear} Closed";
            const string fileName = "Test.csv";

            var config = new LocalConfig();

            var fileLines = LinesFromText(
                "FCT.Operations.Cda.Tests",
                "TestResources.CDA Last Approved Version 16-19 Funding 17-18.csv");

            Assert.IsTrue(fileLines.Count > 0, "Test resource file must not be empty.");

            var cdaRows = fileLines
                .Skip(1)
                .Select(f =>
                {
                    var cols = f.Split(',');
                    return new CdaRow { FundingStreamPeriodCode = cols[0] };
                })
                .ToList();

            var office365Wrapper = new Office365StorageWrapper(
                config,
                Mock.Of<ILogger>(),
                new AuthenticationHelper(new SharepointOAuthAccessTokenFactory(config)));

            // ------------------------------------------------------------
            // Ensure clean test state (Graph-safe, ACS-free)
            // Delete the file IF it exists anywhere under CDA Reports/Archive/_2020 Closed
            // ------------------------------------------------------------
            RemoveFileFromSharePoint(
                parentFolderPath,
                closedFolderName,
                fileName,
                office365Wrapper,
                config);

            var service = new ClosedReportService(office365Wrapper, config);

            // ------------------------------------------------------------
            // act — upload if missing (Graph-over-HTTP inside wrapper)
            // ------------------------------------------------------------
            service.UploadReportToSharePointIfNecessary(
                new Report(cdaRows, fileName, true)
                {
                    ArchivedYear = archivedYear
                });

            // ------------------------------------------------------------
            // assert — verify upload worked by reading file content back
            // ------------------------------------------------------------

            var linesInUploadedFile = GetFileLinesOfUploadedFile(
                office365Wrapper,
                parentFolderPath,
                closedFolderName,
                fileName,
                config);


            Assert.AreEqual(
                fileLines.Count,
                linesInUploadedFile.Count,
                "Uploaded file content mismatch.");
        }


        [TestMethod, TestCategory("IntegrationTest")]
        public void ClosedReportService_UploadReportToSharePointIfNecessary_ShouldNotUploadWhenReportAlreadyExists()
        {
            // arrange
            const string parentFolderPath = "CDA Reports/Archive";
            const int archivedYear = 2020;
            var closedFolderName = $"_{archivedYear} Closed";
            const string fileName = "Test.csv";
            var config = new LocalConfig();

            var fileLines = LinesFromText("FCT.Operations.Cda.Tests",
                "TestResources.CDA Last Approved Version 16-19 Funding 17-18.csv");
            Assert.IsTrue(fileLines.Count > 0);

            var cdaRows = fileLines.Skip(1).Select(f =>
            {
                var cols = f.Split(',');
                return new CdaRow { FundingStreamPeriodCode = cols[0] };
            }).ToList();

            var office365Wrapper = new Office365StorageWrapper(
                config,
                Mock.Of<ILogger>(),
                new AuthenticationHelper(new SharepointOAuthAccessTokenFactory(config)));

            var service = new ClosedReportService(office365Wrapper, config);

            // Ensure clean (delete if exists), then upload once
            RemoveFileFromSharePoint(parentFolderPath, closedFolderName, fileName, office365Wrapper, config);
            service.UploadReportToSharePointIfNecessary(new Report(cdaRows, fileName, true) { ArchivedYear = archivedYear });

            // Baseline version count AFTER first upload
            var preActSharePointFileVersionCount =
                GetSharePointFileVersionCount(parentFolderPath, closedFolderName, fileName, office365Wrapper, config);

            // act (attempt duplicate)
            service.UploadReportToSharePointIfNecessary(new Report(cdaRows, fileName, true) { ArchivedYear = archivedYear });

            var postActSharePointFileVersionCount =
                GetSharePointFileVersionCount(parentFolderPath, closedFolderName, fileName, office365Wrapper, config);

            // assert (no new version if service skipped duplicate)
            Assert.AreEqual(preActSharePointFileVersionCount, postActSharePointFileVersionCount,
                "File was incorrectly uploaded to SharePoint");
        }

        private static IList<string> GetFileLinesOfUploadedFile(
            Office365StorageWrapper wrapper,
            string parentFolderPath,
            string closedFolderName,
            string fileName,
            IFcsConfiguration config)
        {
            var libraryDisplayName = ConfigurationManager.AppSettings["ReportDelivery.CdaO365Folder"];
            if (string.IsNullOrWhiteSpace(libraryDisplayName))
                throw new InvalidOperationException("AppSetting 'ReportDelivery.CdaO365Folder' must contain the library display name.");

            using (var http = GraphClient(config))
            {
                var siteId = ResolveSiteId(http, config["ida:Resource"]);
                var driveId = ResolveDriveIdByDisplayName(http, siteId, libraryDisplayName);

                // Build full folder path EXACTLY like upload uses
                var folderPath = $"{parentFolderPath}/{closedFolderName}".Replace("\\", "/");

                // Resolve folder by path
                var folderUrl =
                    $"https://graph.microsoft.com/v1.0/drives/{driveId}/root:/{Uri.EscapeDataString(folderPath)}";

                var folderResp = http.GetAsync(folderUrl).Result;
                folderResp.EnsureSuccessStatusCode();

                var folderJson = JObject.Parse(folderResp.Content.ReadAsStringAsync().Result);
                var folderId = (string)folderJson["id"];

                if (folderId == null)
                    throw new DirectoryNotFoundException($"Folder '{folderPath}' not found.");

                // List items in folder
                var childrenUrl =
                    $"https://graph.microsoft.com/v1.0/drives/{driveId}/items/{folderId}/children?$select=id,name,file";

                var itemsResp = http.GetAsync(childrenUrl).Result;
                itemsResp.EnsureSuccessStatusCode();

                var itemsJson = JObject.Parse(itemsResp.Content.ReadAsStringAsync().Result);

                var match = itemsJson["value"]
                    .Where(v => v["file"] != null)
                    .FirstOrDefault(v =>
                        string.Equals((string)v["name"], fileName, StringComparison.OrdinalIgnoreCase));

                if (match == null)
                    throw new FileNotFoundException($"File '{fileName}' not found inside '{folderPath}'.");

                string itemId = (string)match["id"];

                // Download content
                http.DefaultRequestHeaders.Accept.Clear();
                http.DefaultRequestHeaders.Accept.Add(
                    new MediaTypeWithQualityHeaderValue("application/octet-stream"));

                var contentResp = http.GetAsync(
                    $"https://graph.microsoft.com/v1.0/drives/{driveId}/items/{itemId}/content").Result;

                contentResp.EnsureSuccessStatusCode();

                var bytes = contentResp.Content.ReadAsByteArrayAsync().Result;
                var csv = Encoding.UTF8.GetString(bytes);

                return Regex
                    .Split(csv, "\r\n|\n|\r")
                    .Where(l => !string.IsNullOrEmpty(l))
                    .ToList();
            }
        }



        /// <summary>
        /// Deletes a file at CDA Reports/Archive/_YYYY Closed/Test.csv using Graph.
        /// </summary>
        private static void RemoveFileFromSharePoint(string parentFolderPath, string closedFolderName, string fileName,
            Office365StorageWrapper office365StorageWrapper, IFcsConfiguration config)
        {
            var pathParts = SplitParent(parentFolderPath); // (library, firstLevelFolder)
            var library = pathParts.library;
            var firstFolder = pathParts.firstFolder;

            using (var http = GraphClient(config))
            {
                var siteId = ResolveSiteId(http, config["ida:Resource"]);
                var driveId = ResolveDriveIdByDisplayName(http, siteId, library);

                // Resolve item id by deep path: /Archive/_YYYY Closed/Test.csv
                var itemId = TryGetItemIdByPath(http, driveId, new[] { firstFolder, closedFolderName, fileName });
                if (itemId == null) return;

                using (var del = http.DeleteAsync($"https://graph.microsoft.com/v1.0/drives/{driveId}/items/{itemId}").Result)
                {
                    // 204/200 accepted
                    if (!del.IsSuccessStatusCode && (int)del.StatusCode != 204)
                    {
                        var body = del.Content.ReadAsStringAsync().Result;
                        throw new InvalidOperationException($"Delete failed: {(int)del.StatusCode} {del.ReasonPhrase}. Body: {body}");
                    }
                }
            }
        }

        /// <summary>
        /// Gets version count for file at CDA Reports/Archive/_YYYY Closed/Test.csv using Graph.
        /// </summary>
        private static int GetSharePointFileVersionCount(string parentFolderPath, string closedFolderName, string fileName,
            Office365StorageWrapper office365StorageWrapper, IFcsConfiguration config)
        {
            var pathParts = SplitParent(parentFolderPath);
            var library = pathParts.library;
            var firstFolder = pathParts.firstFolder;

            using (var http = GraphClient(config))
            {
                var siteId = ResolveSiteId(http, config["ida:Resource"]);
                var driveId = ResolveDriveIdByDisplayName(http, siteId, library);

                var itemId = TryGetItemIdByPath(http, driveId, new[] { firstFolder, closedFolderName, fileName });
                if (itemId == null) return 0;

                var url = $"https://graph.microsoft.com/v1.0/drives/{driveId}/items/{itemId}/versions?$top=200";
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
        }

        // ------------- Small Graph helpers (test-local) -------------

        private static (string library, string firstFolder) SplitParent(string parentFolderPath)
        {
            // "CDA Reports/Archive" -> ("CDA Reports", "Archive")
            if (string.IsNullOrWhiteSpace(parentFolderPath))
                throw new ArgumentException("parentFolderPath must not be empty.");
            var idx = parentFolderPath.IndexOf('/');
            if (idx < 0) return (parentFolderPath.Trim(), "");
            return (parentFolderPath.Substring(0, idx).Trim(), parentFolderPath.Substring(idx + 1).Trim());
        }

        private static HttpClient GraphClient(IFcsConfiguration config)
        {
            var tokenFactory = new SharepointOAuthAccessTokenFactory(config);
            var auth = new AuthenticationHelper(tokenFactory);
            var http = auth.EnsureClient(config["ida:Resource"]);
            // Ensure JSON accept for metadata calls
            http.DefaultRequestHeaders.Accept.Remove(new MediaTypeWithQualityHeaderValue("*/*"));
            http.DefaultRequestHeaders.Accept.ParseAdd("application/json");
            return http;
        }

        private static string ResolveSiteId(HttpClient http, string siteUrl)
        {
            if (string.IsNullOrWhiteSpace(siteUrl))
                throw new InvalidOperationException("ida:Resource must be set to the full site URL.");
            var u = new Uri(siteUrl);
            var host = u.Host;
            var path = u.AbsolutePath;
            using (var resp = http.GetAsync($"https://graph.microsoft.com/v1.0/sites/{host}:{path}").Result)
            {
                resp.EnsureSuccessStatusCode();
                var j = JObject.Parse(resp.Content.ReadAsStringAsync().Result);
                return (string)j["id"];
            }
        }

        private static string ResolveDriveIdByDisplayName(HttpClient http, string siteId, string libraryDisplayName)
        {
            if (string.IsNullOrWhiteSpace(siteId))
                throw new ArgumentNullException(nameof(siteId));
            if (string.IsNullOrWhiteSpace(libraryDisplayName))
                throw new ArgumentNullException(nameof(libraryDisplayName));

            // Normalize the requested name
            var requested = libraryDisplayName.Trim();

            // Collect all drives (handle pagination)
            var drives = new List<JToken>();
            var url = $"https://graph.microsoft.com/v1.0/sites/{siteId}/drives?$select=id,name,driveType,webUrl";
            while (!string.IsNullOrEmpty(url))
            {
                using (var resp = http.GetAsync(url).Result)
                {
                    resp.EnsureSuccessStatusCode();
                    var j = JObject.Parse(resp.Content.ReadAsStringAsync().Result);
                    var page = j["value"]?.ToList() ?? new List<JToken>();
                    drives.AddRange(page);
                    url = (string)j["@odata.nextLink"];
                }
            }

            // Consider only document libraries
            var docLibraries = drives.Where(d =>
                string.Equals((string)d["driveType"], "documentLibrary", StringComparison.OrdinalIgnoreCase)).ToList();

            // 1) Exact match on Title (Graph 'name' is the library Title)
            var direct = docLibraries.FirstOrDefault(d =>
                string.Equals(((string)d["name"])?.Trim(), requested, StringComparison.OrdinalIgnoreCase));
            if (direct != null) return (string)direct["id"];

            // 2) Known default library mapping: "Shared Documents" (URL) vs "Documents" (Title)
            if (string.Equals(requested, "Shared Documents", StringComparison.OrdinalIgnoreCase))
            {
                var defaultDocs = docLibraries.FirstOrDefault(d =>
                    string.Equals(((string)d["name"])?.Trim(), "Documents", StringComparison.OrdinalIgnoreCase));
                if (defaultDocs != null) return (string)defaultDocs["id"];
            }

            // 3) Try matching by webUrl segment (some configs store the URL name instead of Title)
            //    e.g., webUrl like .../Shared%20Documents or .../CDA%20Reports
            var normalizedRequestedUrlSegment = Uri.EscapeDataString(requested.Replace("\\", "/"));
            var byUrlSegment = docLibraries.FirstOrDefault(d =>
            {
                var webUrl = ((string)d["webUrl"]) ?? "";
                // Compare after decoding and case-insensitive
                var decoded = Uri.UnescapeDataString(webUrl);
                return decoded.IndexOf(normalizedRequestedUrlSegment, StringComparison.OrdinalIgnoreCase) >= 0
                       || decoded.IndexOf(requested, StringComparison.OrdinalIgnoreCase) >= 0;
            });
            if (byUrlSegment != null) return (string)byUrlSegment["id"];

            // 4) If still not found, throw with diagnostics listing all available libraries
            var available = string.Join(Environment.NewLine, docLibraries.Select(d =>
            {
                var n = (string)d["name"] ?? "(null)";
                var w = (string)d["webUrl"] ?? "(null)";
                return $" - name='{n}', webUrl='{w}'";
            }));

            throw new InvalidOperationException(
                $"Document library not found: '{libraryDisplayName}'.{Environment.NewLine}" +
                $"SiteId: {siteId}{Environment.NewLine}" +
                $"Available document libraries:{Environment.NewLine}{available}{Environment.NewLine}" +
                $"Tips: Use the library Title shown in SharePoint 'Site contents'. " +
                $"For the default library, try 'Documents'. If you meant a folder (e.g., 'CDA Reports'), " +
                $"set the app setting to the parent library (e.g., 'Documents') and keep folders in the path.");
        }


        private static string CombinePath(params string[] segments)
        {
            return string.Join("/", segments.Where(s => !string.IsNullOrEmpty(s)).Select(s => Uri.EscapeDataString(s)));
        }

        private static string TryGetItemIdByPath(HttpClient http, string driveId, string[] pathSegments)
        {
            var path = CombinePath(pathSegments);
            var url = $"https://graph.microsoft.com/v1.0/drives/{driveId}/root:/{path}";
            using (var resp = http.GetAsync(url).Result)
            {
                if (resp.IsSuccessStatusCode)
                {
                    var j = JObject.Parse(resp.Content.ReadAsStringAsync().Result);
                    return (string)j["id"];
                }
                if ((int)resp.StatusCode == 404) return null;
                var body = resp.Content.ReadAsStringAsync().Result;
                throw new InvalidOperationException($"TryGetItemIdByPath failed: {(int)resp.StatusCode} {resp.ReasonPhrase}. Body: {body}");
            }
        }

        // ------------- Utilities -------------

        private static IReadOnlyCollection<string> LinesFromText(string nameSpace, string resourceName)
        {
            // Use this test class's assembly to avoid runner/adapter "calling assembly" issues
            using (Stream stream = typeof(ClosedReportServiceTests).Assembly
                .GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                List<string> lines = new List<string>();
                while (!streamReader.EndOfStream)
                {
                    lines.Add(streamReader.ReadLine());
                }
                return lines;
            }
        }

        private class LocalConfig : IFcsConfiguration
        {
            public string this[string key]
            {
                get
                {
                    var configConnectionString = ConfigurationManager.ConnectionStrings[key];
                    if (configConnectionString != null)
                        return configConnectionString.ConnectionString;
                    return ConfigurationManager.AppSettings[key];
                }
            }
        }
    }
}
