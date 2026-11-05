namespace CrossDomain.Integration.Common.Tests.Unit.Storage
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Text;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Exceptions;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    [TestClass]
    public class Office365StorageWrapperUnitTests
    {
        private const string DriveId = "drive-id";
        private const string SiteId = "site-id";
        private const string LibraryName = "TestLibrary";
        private string _originalResource;
        private RecordingHandler _handler;
        private Office365StorageWrapper _wrapper;

        [TestInitialize]
        public void SetUp()
        {
            _originalResource = ConfigurationManager.AppSettings["ida:Resource"];
            ConfigurationManager.AppSettings["ida:Resource"] = "https://example.sharepoint.com/sites/unit-test";
            _handler = new RecordingHandler(Respond);
            _wrapper = new Office365StorageWrapper(() => new HttpClient(_handler, disposeHandler: false));
        }

        [TestCleanup]
        public void TearDown()
        {
            ConfigurationManager.AppSettings["ida:Resource"] = _originalResource;
            _handler.Dispose();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetAllFiles_returnsFilesAcrossPagesAndSkipsFolders()
        {
            _handler.Responder = request =>
            {
                if (request.RequestUri.AbsolutePath.EndsWith("/root/children", StringComparison.Ordinal) &&
                    !request.RequestUri.Query.Contains("page=2"))
                {
                    return Json(HttpStatusCode.OK,
                        "{\"value\":[{\"name\":\"one.txt\",\"file\":{}},{\"name\":\"folder\",\"folder\":{}}]," +
                        "\"@odata.nextLink\":\"https://graph.microsoft.com/v1.0/drives/drive-id/root/children?page=2\"}");
                }
                if (request.RequestUri.Query.Contains("page=2"))
                    return Json(HttpStatusCode.OK, "{\"value\":[{\"name\":\"two.txt\",\"file\":{}}]}");
                return Respond(request);
            };

            var files = _wrapper.GetAllFiles(LibraryName);

            CollectionAssert.AreEqual(new[] { "one.txt", "two.txt" }, files);
            Assert.AreEqual(2, _handler.Requests.Count(r => r.Uri.Contains("/root/children")));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetFilenamesByFileNameStartText_escapesODataPrefix()
        {
            _handler.Responder = request =>
            {
                if (request.RequestUri.AbsolutePath.EndsWith("/root/children", StringComparison.Ordinal))
                    return Json(HttpStatusCode.OK, "{\"value\":[{\"name\":\"O'Brien.txt\",\"file\":{}},{\"name\":\"Folder\",\"folder\":{}}]}");
                return Respond(request);
            };

            var files = _wrapper.GetFilenamesByFileNameStartText(LibraryName, "O'Brien");

            CollectionAssert.AreEqual(new[] { "O'Brien.txt" }, files.ToArray());
            StringAssert.Contains(Uri.UnescapeDataString(_handler.Requests.Single(r => r.Uri.Contains("/root/children")).Uri),
                "startswith(name,'O''Brien')");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetFilesByFileNameStartText_downloadsEachMatchingFile()
        {
            _handler.Responder = request =>
            {
                if (request.RequestUri.AbsolutePath.EndsWith("/root/children", StringComparison.Ordinal))
                    return Json(HttpStatusCode.OK, "{\"value\":[{\"name\":\"report.csv\",\"file\":{}}]}");
                if (request.RequestUri.AbsolutePath.EndsWith("/report.csv:/content", StringComparison.Ordinal))
                    return Bytes(HttpStatusCode.OK, new byte[] { 1, 2, 3 });
                return Respond(request);
            };

            var files = _wrapper.GetFilesByFileNameStartText(LibraryName, "report");

            CollectionAssert.AreEqual(new byte[] { 1, 2, 3 }, files["report.csv"]);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MetadataMethods_resolveFileFolderLibraryAndTimestamp()
        {
            Assert.IsTrue(_wrapper.DoesFileExist(LibraryName, "file.txt"));
            Assert.IsTrue(_wrapper.DoesFileExist(LibraryName, "folder", "file.txt"));
            Assert.IsTrue(_wrapper.DoesFolderExist(LibraryName, "folder"));
            Assert.IsTrue(_wrapper.DoesLibraryExist(LibraryName));
            Assert.AreEqual(new DateTime(2024, 1, 2, 3, 4, 5, DateTimeKind.Utc),
                _wrapper.GetFileTimestamp("file.txt", LibraryName));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetFileVersionCount_countsVersionsAcrossPages()
        {
            _handler.Responder = request =>
            {
                if (request.RequestUri.AbsolutePath.EndsWith("/versions", StringComparison.Ordinal))
                {
                    if (request.RequestUri.Query.Contains("page=2"))
                        return Json(HttpStatusCode.OK, "{\"value\":[{\"id\":\"v3\"}]}");
                    return Json(HttpStatusCode.OK,
                        "{\"value\":[{\"id\":\"v1\"},{\"id\":\"v2\"}],\"@odata.nextLink\":\"https://graph.microsoft.com/v1.0/drives/drive-id/root:/file.txt:/versions?page=2\"}");
                }
                return Respond(request);
            };

            Assert.AreEqual(3, _wrapper.GetFileVersionCount("file.txt", LibraryName));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UploadMethods_sendContentAndCreateFolderPaths()
        {
            _handler.Responder = request =>
            {
                var path = request.RequestUri.AbsolutePath;
                if (request.Method == HttpMethod.Get &&
                    (path.EndsWith("/root:/child", StringComparison.Ordinal) ||
                     path.EndsWith("/root:/new-folder", StringComparison.Ordinal) ||
                     path.EndsWith("/root:/bulk", StringComparison.Ordinal)))
                    return Json(HttpStatusCode.NotFound, string.Empty);
                return Respond(request);
            };

            _wrapper.UploadFile("file.txt", new byte[] { 1 }, LibraryName);
            _wrapper.UpsertFile("upsert.txt", new byte[] { 2 }, LibraryName);
            _wrapper.UploadFileToFolderWithOverwrite(LibraryName, "child", new byte[] { 3 }, "nested.txt");
            _wrapper.UploadFile("folder-file.txt", new byte[] { 4 }, LibraryName, "new-folder");
            _wrapper.UploadFilesToFolderWithOverwrite(LibraryName, "bulk", new[]
            {
                new Office365FileInfo("one.txt", new byte[] { 5 }),
                new Office365FileInfo("two.txt", null)
            });

            Assert.AreEqual(6, _handler.Requests.Count(r => r.Method == "PUT"));
            Assert.IsTrue(_handler.Requests.Any(r => r.Method == "POST" && r.Uri.Contains("/children")));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeleteMethods_deleteExistingFilesAndIgnoreMissingFiles()
        {
            _wrapper.DeleteFile("file.txt", LibraryName);
            _wrapper.DeleteFile("file.txt", LibraryName, "folder");

            _handler.Responder = request =>
            {
                if (request.RequestUri.AbsolutePath.Contains("/root:/missing.txt"))
                    return Json(HttpStatusCode.NotFound, string.Empty);
                return Respond(request);
            };
            _wrapper.DeleteFile("missing.txt", LibraryName);

            Assert.AreEqual(2, _handler.Requests.Count(r => r.Method == "DELETE"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RenameAndMoveMethods_patchAndMoveResolvedItems()
        {
            _wrapper.RenameFile("old.txt", "new.txt", LibraryName);
            _wrapper.MoveFileWithRename("file.txt", LibraryName, LibraryName, "moved.txt");

            Assert.IsTrue(_handler.Requests.Any(r => r.Method == "PATCH" && r.Body.Contains("\"name\": \"new.txt\"")));
            Assert.IsTrue(_handler.Requests.Any(r => r.Method == "POST" && r.Uri.EndsWith("/move", StringComparison.Ordinal)));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MoveFileWithRename_acrossLibrariesCopiesAndPermanentlyDeletesSource()
        {
            _handler.Responder = request =>
            {
                if (request.RequestUri.AbsolutePath.EndsWith("/drives", StringComparison.Ordinal))
                    return Json(HttpStatusCode.OK,
                        "{\"value\":[{\"id\":\"drive-id\",\"name\":\"TestLibrary\",\"driveType\":\"documentLibrary\"}," +
                        "{\"id\":\"other-drive\",\"name\":\"OtherLibrary\",\"driveType\":\"documentLibrary\"}]}");
                return Respond(request);
            };

            _wrapper.MoveFileWithRename("file.txt", LibraryName, "OtherLibrary", "moved.txt");

            Assert.IsTrue(_handler.Requests.Any(r => r.Method == "POST" && r.Uri.EndsWith("/items/item-id/copy", StringComparison.Ordinal)));
            Assert.IsTrue(_handler.Requests.Any(r => r.Method == "POST" && r.Uri.EndsWith("/items/item-id/permanentDelete", StringComparison.Ordinal)));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MissingItem_isNotReportedAsExistingOrMovedOrDeleted()
        {
            _handler.Responder = request =>
            {
                if (request.RequestUri.AbsolutePath.Contains("/root:/missing.txt"))
                    return Json(HttpStatusCode.NotFound, string.Empty);
                return Respond(request);
            };

            Assert.IsFalse(_wrapper.DoesFileExist(LibraryName, "missing.txt"));
            _wrapper.DeleteFile("missing.txt", LibraryName);
            _wrapper.MoveFile("missing.txt", LibraryName, LibraryName);

            Assert.IsFalse(_handler.Requests.Any(r => r.Method == "DELETE"));
            Assert.IsFalse(_handler.Requests.Any(r => r.Method == "POST" && r.Uri.EndsWith("/move", StringComparison.Ordinal)));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DoesLibraryExist_fallsBackToDocumentLibraryListWhenDrivesAreMissing()
        {
            _handler.Responder = request =>
            {
                var path = request.RequestUri.AbsolutePath;
                if (path.EndsWith("/drives", StringComparison.Ordinal))
                    return Json(HttpStatusCode.OK, "{\"value\":[]}");
                if (path.EndsWith("/lists", StringComparison.Ordinal))
                    return Json(HttpStatusCode.OK,
                        "{\"value\":[{\"id\":\"list-id\",\"displayName\":\"FallbackLibrary\",\"list\":{\"template\":\"documentLibrary\"}}]}");
                if (path.EndsWith("/lists/list-id/drive", StringComparison.Ordinal))
                    return Json(HttpStatusCode.OK, "{\"id\":\"fallback-drive\",\"name\":\"FallbackLibrary\"}");
                return Respond(request);
            };

            Assert.IsTrue(_wrapper.DoesLibraryExist("FallbackLibrary"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLibraryAndFolders_createMissingGraphResources()
        {
            _handler.Responder = request =>
            {
                if (request.RequestUri.AbsolutePath.EndsWith("/lists", StringComparison.Ordinal) &&
                    request.Method == HttpMethod.Get)
                    return Json(HttpStatusCode.OK, "{\"value\":[]}");
                if (request.RequestUri.AbsolutePath.Contains("/root:/missing-folder") &&
                    request.Method == HttpMethod.Get)
                    return Json(HttpStatusCode.NotFound, string.Empty);
                return Respond(request);
            };

            _wrapper.CreateLibrary("NewLibrary");
            _wrapper.CreateFolder(LibraryName, "missing-folder");
            _wrapper.CreateFolder(LibraryName, "parent", "child");

            Assert.IsTrue(_handler.Requests.Any(r => r.Method == "POST" && r.Uri.EndsWith("/lists", StringComparison.Ordinal)));
            Assert.IsTrue(_handler.Requests.Any(r => r.Method == "POST" && r.Uri.Contains("/children")));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RemoveOldFilesFromFolder_walksFoldersAndDeletesExpiredFiles()
        {
            _handler.Responder = request =>
            {
                if (request.RequestUri.AbsolutePath.EndsWith("/root/children", StringComparison.Ordinal))
                    return Json(HttpStatusCode.OK,
                        "{\"value\":[{\"id\":\"old-root\",\"file\":{},\"lastModifiedDateTime\":\"2000-01-01T00:00:00Z\"}," +
                        "{\"id\":\"folder-id\",\"folder\":{}}]}");
                if (request.RequestUri.AbsolutePath.EndsWith("/items/folder-id/children", StringComparison.Ordinal))
                    return Json(HttpStatusCode.OK,
                        "{\"value\":[{\"id\":\"old-child\",\"file\":{},\"lastModifiedDateTime\":\"2000-01-01T00:00:00Z\"}," +
                        "{\"id\":\"fresh\",\"file\":{},\"lastModifiedDateTime\":\"2999-01-01T00:00:00Z\"}]}");
                return Respond(request);
            };

            _wrapper.RemoveOldFilesFromFolder(LibraryName, 30);

            CollectionAssert.AreEquivalent(
                new[] { "https://graph.microsoft.com/v1.0/drives/drive-id/items/old-root", "https://graph.microsoft.com/v1.0/drives/drive-id/items/old-child" },
                _handler.Requests.Where(r => r.Method == "DELETE").Select(r => r.Uri).ToArray());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MissingDownloadsThrowAndGetAllFilesReturnsEmptyOnGraphError()
        {
            _handler.Responder = request =>
            {
                if (request.RequestUri.AbsolutePath.EndsWith("/root/children", StringComparison.Ordinal))
                    return Json(HttpStatusCode.InternalServerError, "unavailable");
                if (request.RequestUri.AbsolutePath.EndsWith("/missing.txt:/content", StringComparison.Ordinal))
                    return Json(HttpStatusCode.NotFound, string.Empty);
                return Respond(request);
            };

            Assert.AreEqual(0, _wrapper.GetAllFiles(LibraryName).Count);
            AssertThrowsFileNotFoundException(() => _wrapper.GetFileContents("missing.txt", LibraryName));
        }

        private HttpResponseMessage Respond(HttpRequestMessage request)
        {
            var path = request.RequestUri.AbsolutePath;
            if (path.Contains("/sites/example.sharepoint.com:/sites/unit-test"))
                return Json(HttpStatusCode.OK, "{\"id\":\"" + SiteId + "\"}");
            if (path.EndsWith("/drives", StringComparison.Ordinal))
                return Json(HttpStatusCode.OK, "{\"value\":[{\"id\":\"" + DriveId + "\",\"name\":\"" + LibraryName +
                    "\",\"driveType\":\"documentLibrary\",\"webUrl\":\"https://example.sharepoint.com/TestLibrary/\"}]}");
            if (path.EndsWith("/lists", StringComparison.Ordinal))
                return Json(HttpStatusCode.OK, "{\"value\":[]}");
            if (request.Method == HttpMethod.Post && path.EndsWith("/children", StringComparison.Ordinal))
                return Json(HttpStatusCode.Created, "{\"id\":\"created-folder\"}");
            if (path.EndsWith("/root/children", StringComparison.Ordinal) || path.EndsWith("/children", StringComparison.Ordinal))
                return Json(HttpStatusCode.OK, "{\"value\":[]}");
            if (path.EndsWith("/versions", StringComparison.Ordinal))
                return Json(HttpStatusCode.OK, "{\"value\":[{\"id\":\"v1\"},{\"id\":\"v2\"}]}");
            if (path.EndsWith("/root", StringComparison.Ordinal))
                return Json(HttpStatusCode.OK, "{\"id\":\"root-id\"}");
            if (path.EndsWith("/content", StringComparison.Ordinal))
                return Bytes(HttpStatusCode.OK, new byte[] { 7, 8, 9 });
            if (request.Method == HttpMethod.Get && path.Contains("/root:/"))
                return Json(HttpStatusCode.OK,
                    "{\"id\":\"item-id\",\"name\":\"existing.txt\",\"folder\":{},\"file\":{}," +
                    "\"lastModifiedDateTime\":\"2024-01-02T03:04:05Z\"}");
            if (request.Method == HttpMethod.Delete)
                return new HttpResponseMessage(HttpStatusCode.NoContent);
            return Json(HttpStatusCode.OK, "{\"id\":\"item-id\",\"value\":[]}");
        }

        private static void AssertThrowsFileNotFoundException(Action action)
        {
            try
            {
                action();
            }
            catch (FileNotFoundException)
            {
                return;
            }

            Assert.Fail("Expected FileNotFoundException.");
        }

        private static HttpResponseMessage Json(HttpStatusCode status, string body)
        {
            return new HttpResponseMessage(status)
            {
                Content = new StringContent(body, Encoding.UTF8, "application/json")
            };
        }

        private static HttpResponseMessage Bytes(HttpStatusCode status, byte[] body)
        {
            return new HttpResponseMessage(status) { Content = new ByteArrayContent(body) };
        }

        private sealed class RecordingHandler : HttpMessageHandler
        {
            private readonly Func<HttpRequestMessage, HttpResponseMessage> _defaultResponder;

            public RecordingHandler(Func<HttpRequestMessage, HttpResponseMessage> defaultResponder)
            {
                _defaultResponder = defaultResponder;
                Responder = defaultResponder;
            }

            public Func<HttpRequestMessage, HttpResponseMessage> Responder { get; set; }
            public List<RecordedRequest> Requests { get; } = new List<RecordedRequest>();

            protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
            {
                var body = request.Content == null ? string.Empty : await request.Content.ReadAsStringAsync().ConfigureAwait(false);
                Requests.Add(new RecordedRequest(request.Method.Method, request.RequestUri.AbsoluteUri, body));
                return (Responder ?? _defaultResponder)(request);
            }
        }

        private sealed class RecordedRequest
        {
            public RecordedRequest(string method, string uri, string body)
            {
                Method = method;
                Uri = uri;
                Body = body;
            }

            public string Method { get; private set; }
            public string Uri { get; private set; }
            public string Body { get; private set; }
        }
    }
}
