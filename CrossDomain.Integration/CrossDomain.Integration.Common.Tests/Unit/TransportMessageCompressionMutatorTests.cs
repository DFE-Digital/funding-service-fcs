namespace CrossDomain.Integration.Common.Tests.Unit
{
    using System.IO;
    using System.IO.Compression;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Common.MessageMutators;

    [TestClass]
    public class TransportMessageCompressionMutatorTests
    {
        private static TransportMessage Message(int size)
        {
            return new TransportMessage { Body = Enumerable.Repeat((byte)'a', size).ToArray() };
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MutateOutgoing_SmallBody_IsLeftUntouched()
        {
            var message = Message(512);

            new TransportMessageCompressionMutator().MutateOutgoing(null, message);

            Assert.AreEqual(512, message.Body.Length);
            Assert.IsFalse(message.Headers.ContainsKey("IWasCompressed"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MutateOutgoing_MediumBody_IsGzippedAndFlagged()
        {
            var message = Message(5000);

            new TransportMessageCompressionMutator().MutateOutgoing(null, message);

            Assert.AreEqual("true", message.Headers["IWasCompressed"]);
            Assert.IsTrue(message.Body.Length < 5000);

            using (var gzip = new GZipStream(new MemoryStream(message.Body), CompressionMode.Decompress))
            using (var result = new MemoryStream())
            {
                gzip.CopyTo(result);
                Assert.AreEqual(5000, result.Length);
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MutateIncoming_CompressedBody_RoundTrips()
        {
            var mutator = new TransportMessageCompressionMutator();
            var message = Message(5000);
            var original = message.Body.ToArray();

            mutator.MutateOutgoing(null, message);
            mutator.MutateIncoming(message);

            CollectionAssert.AreEqual(original, message.Body);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MutateIncoming_NoMarkerHeaders_LeavesBodyUnchanged()
        {
            var message = Message(100);
            var original = message.Body.ToArray();

            new TransportMessageCompressionMutator().MutateIncoming(message);

            CollectionAssert.AreEqual(original, message.Body);
        }
    }
}
