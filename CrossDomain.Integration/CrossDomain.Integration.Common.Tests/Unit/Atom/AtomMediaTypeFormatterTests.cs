namespace CrossDomain.Integration.Common.Tests.Unit.Atom
{
    using System.IO;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.ServiceModel.Syndication;
    using System.Text;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Atom;

    [TestClass]
    public class AtomMediaTypeFormatterTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CanReadAndWrite_onlySyndicationFeeds()
        {
            var formatter = new AtomMediaTypeFormatter(new[] { "APPLICATION/ATOM+XML" });

            Assert.IsTrue(formatter.CanReadType(typeof(SyndicationFeed)));
            Assert.IsTrue(formatter.CanWriteType(typeof(SyndicationFeed)));
            Assert.IsFalse(formatter.CanReadType(typeof(string)));
            Assert.IsFalse(formatter.CanWriteType(typeof(string)));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WriteToStreamAsync_serializesAtomXmlWhenXmlIsSupported()
        {
            var formatter = new AtomMediaTypeFormatter(new[] { "APPLICATION/ATOM+XML" });
            var feed = new SyndicationFeed
            {
                Title = new TextSyndicationContent("Test feed")
            };

            using (var content = new StringContent(string.Empty))
            using (var stream = new MemoryStream())
            {
                content.Headers.ContentType = new MediaTypeHeaderValue("application/atom+xml");
                formatter.WriteToStreamAsync(typeof(SyndicationFeed), feed, stream, content, null).GetAwaiter().GetResult();

                var xml = Encoding.UTF8.GetString(stream.ToArray());
                StringAssert.Contains(xml, "<feed");
                StringAssert.Contains(xml, "Test feed");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WriteToStreamAsync_doesNotSerializeUnsupportedTypesOrAtomJson()
        {
            var formatter = new AtomMediaTypeFormatter(new[] { "APPLICATION/ATOM+XML" });
            var feed = new SyndicationFeed
            {
                Title = new TextSyndicationContent("Test feed")
            };

            using (var content = new StringContent(string.Empty))
            using (var stream = new MemoryStream())
            {
                content.Headers.ContentType = new MediaTypeHeaderValue("application/atom+json");
                formatter.WriteToStreamAsync(typeof(SyndicationFeed), feed, stream, content, null).GetAwaiter().GetResult();
                Assert.AreEqual(0, stream.Length);

                formatter.WriteToStreamAsync(typeof(string), "not a feed", stream, content, null).GetAwaiter().GetResult();
                Assert.AreEqual(0, stream.Length);
            }
        }
    }
}
