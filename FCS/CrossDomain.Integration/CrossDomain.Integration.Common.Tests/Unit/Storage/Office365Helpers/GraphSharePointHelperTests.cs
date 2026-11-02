namespace CrossDomain.Integration.Common.Tests.Unit.Storage.Office365Helpers
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
    using SFA.FCT.CrossDomain.Integration.Common.Storage.Office365Helpers;

    [TestClass]
    public class GraphSharePointHelperTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ResolveSiteId_throwsWhenConfiguredSiteUrlIsMissing()
        {
            var originalResource = ConfigurationManager.AppSettings["ida:Resource"];

            try
            {
                ConfigurationManager.AppSettings["ida:Resource"] = " ";

                using (var client = new HttpClient(new RecordingHandler(_ => Json(HttpStatusCode.OK, "{\"id\":\"site-id\"}"))))
                {
                    var exception = AssertThrowsInvalidOperationException(() => GraphSharePointHelper.ResolveSiteId(client));

                    StringAssert.Contains(exception.Message, "AppSetting 'ida:Resource' is required");
                }
            }
            finally
            {
                ConfigurationManager.AppSettings["ida:Resource"] = originalResource;
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ResolveSiteId_throwsWhenConfiguredSiteUrlIsNotAbsolute()
        {
            var originalResource = ConfigurationManager.AppSettings["ida:Resource"];

            try
            {
                ConfigurationManager.AppSettings["ida:Resource"] = "relative/site";

                using (var client = new HttpClient(new RecordingHandler(_ => Json(HttpStatusCode.OK, "{\"id\":\"site-id\"}"))))
                {
                    var exception = AssertThrowsInvalidOperationException(() => GraphSharePointHelper.ResolveSiteId(client));

                    StringAssert.Contains(exception.Message, "ida:Resource must be an absolute SharePoint site URL: relative/site");
                }
            }
            finally
            {
                ConfigurationManager.AppSettings["ida:Resource"] = originalResource;
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ResolveSiteId_usesConfiguredSiteHostAndPath()
        {
            var handler = new RecordingHandler(_ => Json(HttpStatusCode.OK, "{\"id\":\"site-id\"}"));

            using (var client = new HttpClient(handler))
            {
                var siteId = GraphSharePointHelper.ResolveSiteId(client);

                Assert.AreEqual("site-id", siteId);
                Assert.AreEqual(
                    "https://graph.microsoft.com/v1.0/sites/educationgovuk.sharepoint.com:/sites/fct-dat/",
                    handler.Requests.Single().RequestUri.AbsoluteUri);
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ResolveDriveIdByDisplayName_matchesLibraryNameWithoutCaseSensitivity()
        {
            var handler = new RecordingHandler(_ => Json(HttpStatusCode.OK, "{\"value\":[{\"id\":\"drive-1\",\"name\":\"Contracts\"}]}"));

            using (var client = new HttpClient(handler))
            {
                Assert.AreEqual("drive-1", GraphSharePointHelper.ResolveDriveIdByDisplayName(client, "site-id", "contracts"));
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ResolveDriveIdByDisplayName_throwsWhenLibraryDoesNotExist()
        {
            var handler = new RecordingHandler(_ => Json(HttpStatusCode.OK, "{\"value\":[]}"));

            using (var client = new HttpClient(handler))
            {
                var exception = AssertThrowsInvalidOperationException(
                    () => GraphSharePointHelper.ResolveDriveIdByDisplayName(client, "site-id", "missing"));

                StringAssert.Contains(exception.Message, "Document library not found: missing");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TryGetItemIdByPath_encodesPathSegmentsAndReturnsItemId()
        {
            var handler = new RecordingHandler(_ => Json(HttpStatusCode.OK, "{\"id\":\"item-id\"}"));

            using (var client = new HttpClient(handler))
            {
                Assert.AreEqual(
                    "item-id",
                    GraphSharePointHelper.TryGetItemIdByPath(client, "drive-id", new[] { "folder name", "file#1" }));
                Assert.AreEqual(
                    "https://graph.microsoft.com/v1.0/drives/drive-id/root:/folder%20name/file%231",
                    handler.Requests.Single().RequestUri.AbsoluteUri);
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TryGetItemIdByPath_returnsNullWhenItemIsMissing()
        {
            var handler = new RecordingHandler(_ => Json(HttpStatusCode.NotFound, string.Empty));

            using (var client = new HttpClient(handler))
            {
                Assert.IsNull(GraphSharePointHelper.TryGetItemIdByPath(client, "drive-id", new[] { "missing" }));
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TryGetItemIdByPath_throwsWithResponseDetailsForOtherFailures()
        {
            var handler = new RecordingHandler(_ => Json(HttpStatusCode.InternalServerError, "service failure"));

            using (var client = new HttpClient(handler))
            {
                var exception = AssertThrowsInvalidOperationException(
                    () => GraphSharePointHelper.TryGetItemIdByPath(client, "drive-id", new[] { "item" }));

                StringAssert.Contains(exception.Message, "500");
                StringAssert.Contains(exception.Message, "service failure");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureFolder_returnsExistingFolderAtDriveRoot()
        {
            var handler = new RecordingHandler(_ => Json(HttpStatusCode.OK, "{\"id\":\"existing-id\"}"));

            using (var client = new HttpClient(handler))
            {
                Assert.AreEqual("existing-id", GraphSharePointHelper.EnsureFolder(client, "drive-id", null, "reports"));
                Assert.AreEqual(1, handler.Requests.Count);
                Assert.AreEqual(HttpMethod.Get, handler.Requests[0].Method);
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureFolder_createsFolderAtDriveRootWhenMissing()
        {
            var handler = new RecordingHandler(request =>
                request.Method == HttpMethod.Get
                    ? Json(HttpStatusCode.NotFound, string.Empty)
                    : Json(HttpStatusCode.Created, "{\"id\":\"created-id\"}"));

            using (var client = new HttpClient(handler))
            {
                Assert.AreEqual("created-id", GraphSharePointHelper.EnsureFolder(client, "drive-id", null, "reports"));
                Assert.AreEqual(HttpMethod.Post, handler.Requests.Last().Method);
                Assert.AreEqual(
                    "https://graph.microsoft.com/v1.0/drives/drive-id/root/children",
                    handler.Requests.Last().RequestUri.AbsoluteUri);

                var body = handler.RequestBodies.Last();
                StringAssert.Contains(body, "\"name\": \"reports\"");
                StringAssert.Contains(body, "\"folder\": {}");
                StringAssert.Contains(body, "\"@microsoft.graph.conflictBehavior\": \"replace\"");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureFolder_returnsExistingChildFolder()
        {
            var handler = new RecordingHandler(_ =>
                Json(HttpStatusCode.OK, "{\"value\":[{\"id\":\"folder-id\",\"name\":\"reports\",\"folder\":{}}]}"));

            using (var client = new HttpClient(handler))
            {
                Assert.AreEqual("folder-id", GraphSharePointHelper.EnsureFolder(client, "drive-id", "parent-id", "reports"));
                Assert.AreEqual(1, handler.Requests.Count);
                Assert.AreEqual(
                    "https://graph.microsoft.com/v1.0/drives/drive-id/items/parent-id/children?$select=id,name,folder",
                    handler.Requests[0].RequestUri.AbsoluteUri);
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureFolder_createsChildFolderWhenNoMatchingFolderExists()
        {
            var handler = new RecordingHandler(request =>
                request.Method == HttpMethod.Get
                    ? Json(HttpStatusCode.OK, "{\"value\":[]}")
                    : Json(HttpStatusCode.Created, "{\"id\":\"child-id\"}"));

            using (var client = new HttpClient(handler))
            {
                Assert.AreEqual("child-id", GraphSharePointHelper.EnsureFolder(client, "drive-id", "parent-id", "reports"));
                Assert.AreEqual(
                    "https://graph.microsoft.com/v1.0/drives/drive-id/items/parent-id/children",
                    handler.Requests.Last().RequestUri.AbsoluteUri);
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UploadSmallFileByPath_sendsBytesWithBinaryContentType()
        {
            var handler = new RecordingHandler(_ => new HttpResponseMessage(HttpStatusCode.Created));

            using (var client = new HttpClient(handler))
            {
                GraphSharePointHelper.UploadSmallFileByPath(client, "drive-id", new[] { "report file.csv" }, new byte[] { 1, 2, 3 });

                Assert.AreEqual(HttpMethod.Put, handler.Requests.Single().Method);
                Assert.AreEqual(
                    "https://graph.microsoft.com/v1.0/drives/drive-id/root:/report%20file.csv:/content",
                    handler.Requests.Single().RequestUri.AbsoluteUri);
                Assert.AreEqual("application/octet-stream", handler.Requests.Single().Content.Headers.ContentType.MediaType);
                CollectionAssert.AreEqual(new byte[] { 1, 2, 3 }, handler.RequestBodiesBytes.Single());
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ItemExistsByPath_returnsTrueForAnExistingItem()
        {
            var handler = new RecordingHandler(_ => Json(HttpStatusCode.OK, "{\"id\":\"item-id\"}"));

            using (var client = new HttpClient(handler))
            {
                Assert.IsTrue(GraphSharePointHelper.ItemExistsByPath(client, "drive-id", new[] { "item" }));
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ItemExistsByPath_returnsFalseForAMissingItem()
        {
            var handler = new RecordingHandler(_ => Json(HttpStatusCode.NotFound, string.Empty));

            using (var client = new HttpClient(handler))
            {
                Assert.IsFalse(GraphSharePointHelper.ItemExistsByPath(client, "drive-id", new[] { "item" }));
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeleteAllSubFolders_doesNothingWhenParentDoesNotExist()
        {
            var handler = new RecordingHandler(_ => Json(HttpStatusCode.NotFound, string.Empty));

            using (var client = new HttpClient(handler))
            {
                GraphSharePointHelper.DeleteAllSubFolders(client, "drive-id", "reports");

                Assert.AreEqual(1, handler.Requests.Count);
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeleteAllSubFolders_deletesFoldersButLeavesFilesUntouched()
        {
            var handler = new RecordingHandler(request =>
            {
                if (request.Method == HttpMethod.Delete)
                {
                    return new HttpResponseMessage(HttpStatusCode.NoContent);
                }

                if (request.RequestUri.AbsolutePath.EndsWith("/children", StringComparison.Ordinal))
                {
                    return Json(HttpStatusCode.OK, "{\"value\":[{\"id\":\"folder-id\",\"folder\":{}},{\"id\":\"file-id\",\"file\":{}}]}");
                }

                return Json(HttpStatusCode.OK, "{\"id\":\"parent-id\"}");
            });

            using (var client = new HttpClient(handler))
            {
                GraphSharePointHelper.DeleteAllSubFolders(client, "drive-id", "reports");

                var deleteRequests = handler.Requests.Where(request => request.Method == HttpMethod.Delete).ToList();
                Assert.AreEqual(1, deleteRequests.Count);
                Assert.IsTrue(deleteRequests[0].RequestUri.AbsolutePath.EndsWith("/items/folder-id", StringComparison.Ordinal));
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeleteAllSubFolders_throwsWhenDeletingChildFolderFails()
        {
            var handler = new RecordingHandler(request =>
            {
                if (request.Method == HttpMethod.Delete)
                {
                    return Json(HttpStatusCode.InternalServerError, "delete failed");
                }

                if (request.RequestUri.AbsolutePath.EndsWith("/children", StringComparison.Ordinal))
                {
                    return Json(HttpStatusCode.OK, "{\"value\":[{\"id\":\"folder-id\",\"folder\":{}}]}");
                }

                return Json(HttpStatusCode.OK, "{\"id\":\"parent-id\"}");
            });

            using (var client = new HttpClient(handler))
            {
                var exception = AssertThrowsInvalidOperationException(
                    () => GraphSharePointHelper.DeleteAllSubFolders(client, "drive-id", "reports"));

                StringAssert.Contains(exception.Message, "delete failed");
            }
        }

        private static HttpResponseMessage Json(HttpStatusCode statusCode, string body)
        {
            return new HttpResponseMessage(statusCode)
            {
                Content = new StringContent(body, Encoding.UTF8, "application/json")
            };
        }

        private static InvalidOperationException AssertThrowsInvalidOperationException(Action action)
        {
            try
            {
                action();
            }
            catch (InvalidOperationException exception)
            {
                return exception;
            }

            Assert.Fail("Expected an InvalidOperationException.");
            return null;
        }

        private sealed class RecordingHandler : HttpMessageHandler
        {
            private readonly Func<HttpRequestMessage, HttpResponseMessage> _responseFactory;

            public RecordingHandler(Func<HttpRequestMessage, HttpResponseMessage> responseFactory)
            {
                _responseFactory = responseFactory;
            }

            public IList<HttpRequestMessage> Requests { get; } = new List<HttpRequestMessage>();

            public IList<string> RequestBodies { get; } = new List<string>();

            public IList<byte[]> RequestBodiesBytes { get; } = new List<byte[]>();

            protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
            {
                Requests.Add(request);
                if (request.Content != null)
                {
                    RequestBodies.Add(await request.Content.ReadAsStringAsync());
                    RequestBodiesBytes.Add(await request.Content.ReadAsByteArrayAsync());
                }

                return _responseFactory(request);
            }
        }
    }
}
