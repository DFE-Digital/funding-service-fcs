using System;
using System.IO;
using System.ServiceModel.Syndication;
using System.Text;
using System.Threading.Tasks;
using ContractManagementService.AtomFeed;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.Formatters;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.ContractManagementService;

namespace ContractManagementService.Tests.UnitTests
{
    [TestClass, TestCategory("UnitTest")]
    public class AtomOutputFormatterTests
    {
        [TestMethod]
        public void AtomOutputFormatter_CanWriteOnlySyndicationFeeds()
        {
            var formatter = new TestAtomOutputFormatter();

            Assert.IsTrue(formatter.CanWrite(typeof(SyndicationFeed)));
            Assert.IsFalse(formatter.CanWrite(typeof(object)));
        }

        [TestMethod]
        public void AtomMediaTypeFormatter_CanWriteOnlySyndicationFeeds()
        {
            var formatter = new TestAtomMediaTypeFormatter();

            Assert.IsTrue(formatter.CanWrite(typeof(SyndicationFeed)));
            Assert.IsFalse(formatter.CanWrite(typeof(object)));
        }

        [TestMethod]
        public async Task AtomOutputFormatter_WritesSyndicationFeedAsAtomXml()
        {
            var formatter = new AtomOutputFormatter();
            var httpContext = new DefaultHttpContext
            {
                Response =
                {
                    Body = new MemoryStream()
                }
            };
            var feed = new SyndicationFeed("Test feed", "Feed description", new Uri("https://example.test/feed"));
            var context = CreateWriteContext(httpContext, typeof(SyndicationFeed), feed);

            await formatter.WriteResponseBodyAsync(context, Encoding.UTF8);

            Assert.IsTrue(ReadResponseBody(httpContext).Contains("Test feed"));
        }

        [TestMethod]
        public async Task AtomOutputFormatter_WithNonFeedObject_WritesAnEmptyResponse()
        {
            var formatter = new AtomOutputFormatter();
            var httpContext = new DefaultHttpContext
            {
                Response =
                {
                    Body = new MemoryStream()
                }
            };
            var context = CreateWriteContext(httpContext, typeof(object), new object());

            await formatter.WriteResponseBodyAsync(context, Encoding.UTF8);

            Assert.AreEqual(string.Empty, ReadResponseBody(httpContext));
        }

        [TestMethod]
        public async Task AtomMediaTypeFormatter_WritesSyndicationFeedAsAtomXml()
        {
            var formatter = new AtomMediaTypeFormatter();
            var httpContext = new DefaultHttpContext
            {
                Response =
                {
                    Body = new MemoryStream()
                }
            };
            var feed = new SyndicationFeed("Test feed", "Feed description", new Uri("https://example.test/feed"));
            var context = CreateWriteContext(httpContext, typeof(SyndicationFeed), feed);

            await formatter.WriteResponseBodyAsync(context, Encoding.UTF8);

            Assert.IsTrue(ReadResponseBody(httpContext).Contains("Test feed"));
        }

        [TestMethod]
        public async Task AtomMediaTypeFormatter_WithNonFeedObject_WritesAnEmptyResponse()
        {
            var formatter = new AtomMediaTypeFormatter();
            var httpContext = new DefaultHttpContext
            {
                Response =
                {
                    Body = new MemoryStream()
                }
            };
            var context = CreateWriteContext(httpContext, typeof(object), new object());

            await formatter.WriteResponseBodyAsync(context, Encoding.UTF8);

            Assert.AreEqual(string.Empty, ReadResponseBody(httpContext));
        }

        private static OutputFormatterWriteContext CreateWriteContext(
            HttpContext httpContext,
            Type objectType,
            object value)
        {
            return new OutputFormatterWriteContext(
                httpContext,
                (stream, encoding) => new StreamWriter(stream, encoding),
                objectType,
                value);
        }

        private static string ReadResponseBody(HttpContext httpContext)
        {
            httpContext.Response.Body.Position = 0;
            using var reader = new StreamReader(httpContext.Response.Body, Encoding.UTF8);
            return reader.ReadToEnd();
        }

        private sealed class TestAtomOutputFormatter : AtomOutputFormatter
        {
            public bool CanWrite(Type type)
            {
                return base.CanWriteType(type);
            }
        }

        private sealed class TestAtomMediaTypeFormatter : AtomMediaTypeFormatter
        {
            public bool CanWrite(Type type)
            {
                return base.CanWriteType(type);
            }
        }
    }
}
