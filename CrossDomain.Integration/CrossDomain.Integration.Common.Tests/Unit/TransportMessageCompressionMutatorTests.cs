namespace CrossDomain.Integration.Common.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.IO.Compression;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus.MessageMutator;
    using SFA.FCT.CrossDomain.Integration.Common.MessageMutators;

    [TestClass]
    public class TransportMessageCompressionMutatorTests
    {
        private static MutateOutgoingTransportMessageContext Message(int size)
        {
            var headers = new Dictionary<string, string>();
            return new MutateOutgoingTransportMessageContext(
                Enumerable.Repeat((byte)'a', size).ToArray(),
                null,
                headers,
                null,
                headers,
                default);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MutateOutgoing_SmallBody_IsLeftUntouched()
        {
            var message = Message(512);

            new TransportMessageCompressionMutator().MutateOutgoing(message).Wait();

            Assert.AreEqual(512, message.OutgoingBody.Length);
            Assert.IsFalse(message.OutgoingHeaders.ContainsKey("IWasCompressed"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MutateOutgoing_MediumBody_IsGzippedAndFlagged()
        {
            var message = Message(5000);

            new TransportMessageCompressionMutator().MutateOutgoing(message).Wait();

            Assert.AreEqual("true", message.OutgoingHeaders["IWasCompressed"]);
            Assert.IsTrue(message.OutgoingBody.Length < 5000);

            using (var gzip = new GZipStream(new MemoryStream(message.OutgoingBody.ToArray()), CompressionMode.Decompress))
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
            var outgoingMessage = Message(5000);
            var original = outgoingMessage.OutgoingBody.ToArray();

            mutator.MutateOutgoing(outgoingMessage).Wait();
            var incomingMessage = new MutateIncomingTransportMessageContext(
                outgoingMessage.OutgoingBody,
                outgoingMessage.OutgoingHeaders,
                default);
            mutator.MutateIncoming(incomingMessage).Wait();

            CollectionAssert.AreEqual(original, incomingMessage.Body.ToArray());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MutateIncoming_NoMarkerHeaders_LeavesBodyUnchanged()
        {
            var outgoingMessage = Message(100);
            var original = outgoingMessage.OutgoingBody.ToArray();
            var incomingMessage = new MutateIncomingTransportMessageContext(
                outgoingMessage.OutgoingBody,
                outgoingMessage.OutgoingHeaders,
                default);

            new TransportMessageCompressionMutator().MutateIncoming(incomingMessage).Wait();

            CollectionAssert.AreEqual(original, incomingMessage.Body.ToArray());
        }
    }
}
