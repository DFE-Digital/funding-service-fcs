namespace CrossDomain.Integration.Common.Tests.Unit.Atom
{
    using System.Net;
    using System.Net.Http;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Atom;

    [TestClass]
    public class AtomMediaTypeFilterHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void SendAsync_rejectsUnsupportedMediaTypeForRestrictedUrl()
        {
            var innerHandler = new RecordingHandler();
            var filter = CreateFilter(innerHandler);
            var request = new HttpRequestMessage(HttpMethod.Get, "https://example.test/contracts/feed");
            request.Headers.Accept.ParseAdd("text/plain");

            using (var invoker = new HttpMessageInvoker(filter))
            using (var response = invoker.SendAsync(request, CancellationToken.None).Result)
            {
                Assert.AreEqual(HttpStatusCode.UnsupportedMediaType, response.StatusCode);
                Assert.IsFalse(innerHandler.WasCalled);
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SendAsync_forwardsSupportedMediaTypeForRestrictedUrl()
        {
            var innerHandler = new RecordingHandler();
            var filter = CreateFilter(innerHandler);
            var request = new HttpRequestMessage(HttpMethod.Get, "https://example.test/contracts/feed");
            request.Headers.Accept.ParseAdd("APPLICATION/ATOM+XML");

            using (var invoker = new HttpMessageInvoker(filter))
            using (var response = invoker.SendAsync(request, CancellationToken.None).Result)
            {
                Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);
                Assert.IsTrue(innerHandler.WasCalled);
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SendAsync_forwardsRequestsForUnrestrictedUrls()
        {
            var innerHandler = new RecordingHandler();
            var filter = CreateFilter(innerHandler);
            var request = new HttpRequestMessage(HttpMethod.Get, "https://example.test/health");

            using (var invoker = new HttpMessageInvoker(filter))
            using (var response = invoker.SendAsync(request, CancellationToken.None).Result)
            {
                Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);
                Assert.IsTrue(innerHandler.WasCalled);
            }
        }

        private static AtomMediaTypeFilterHandler CreateFilter(HttpMessageHandler innerHandler)
        {
            return new AtomMediaTypeFilterHandler(new[]
            {
                new MediaTypeFilterCriteria
                {
                    UrlPortion = "/contracts",
                    SupportedMediaTypes = new[] { "application/atom+xml" }
                }
            })
            {
                InnerHandler = innerHandler
            };
        }

        private sealed class RecordingHandler : HttpMessageHandler
        {
            public bool WasCalled { get; private set; }

            protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
            {
                WasCalled = true;
                return Task.FromResult(new HttpResponseMessage(HttpStatusCode.OK));
            }
        }
    }
}
