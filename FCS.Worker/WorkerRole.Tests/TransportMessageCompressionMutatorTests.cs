namespace WorkerRole.Tests
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.IO.Compression;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.MessageMutator;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class TransportMessageCompressionMutatorTests
    {
        private TransportMessageCompressionMutator _mutator;

        [TestInitialize]
        public void Setup()
        {
            _mutator = new TransportMessageCompressionMutator(Mock.Of<ILogger>());
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task MutateOutgoing_WhenBodyIsSmall_ShouldLeaveBodyAndHeadersUnchanged()
        {
            var body = Enumerable.Repeat((byte)'a', 100).ToArray();
            var context = CreateOutgoingContext(body);

            await _mutator.MutateOutgoing(context);

            CollectionAssert.AreEqual(body, context.OutgoingBody);
            Assert.IsFalse(context.OutgoingHeaders.ContainsKey("IWasCompressed"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task MutateOutgoing_WhenBodyExceedsOneKb_ShouldGzipBodyAndSetCompressedHeader()
        {
            var body = Enumerable.Repeat((byte)'a', 5000).ToArray();
            var context = CreateOutgoingContext(body);

            await _mutator.MutateOutgoing(context);

            Assert.IsTrue(context.OutgoingBody.IsZipped());
            Assert.IsTrue(context.OutgoingBody.Length < body.Length);
            Assert.AreEqual("true", context.OutgoingHeaders["IWasCompressed"]);
            CollectionAssert.AreEqual(body, Decompress(context.OutgoingBody));
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task MutateIncoming_WhenBodyIsNotZipped_ShouldLeaveBodyUntouched()
        {
            var body = new byte[] { 1, 2, 3, 4, 5 };
            var context = new MutateIncomingTransportMessageContext(body, new Dictionary<string, string>());

            await _mutator.MutateIncoming(context);

            CollectionAssert.AreEqual(body, context.Body);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task MutateIncoming_WhenBodyIsZipped_ShouldDecompressBodyAndRemoveCompressedHeader()
        {
            var original = Enumerable.Repeat((byte)'b', 5000).ToArray();
            var outgoing = CreateOutgoingContext(original);
            await _mutator.MutateOutgoing(outgoing);
            var headers = new Dictionary<string, string> { { "IWasCompressed", "true" } };
            var context = new MutateIncomingTransportMessageContext(outgoing.OutgoingBody, headers);

            await _mutator.MutateIncoming(context);

            CollectionAssert.AreEqual(original, context.Body);
            Assert.IsFalse(context.Headers.ContainsKey("IWasCompressed"));
        }

        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof(InvalidDataException))]
        public async Task MutateIncoming_WhenZippedBodyIsCorrupt_ShouldLogErrorAndRethrow()
        {
            var corrupt = new byte[] { 0x1f, 0x8b, 8, 0, 0, 0, 0, 0, 4, 0, 0xFF, 0xFF, 0xFF, 0xFF };
            var headers = new Dictionary<string, string> { { "NServiceBus.EnclosedMessageTypes", "Some.Type" } };
            var loggerMock = new Mock<ILogger>();
            var mutator = new TransportMessageCompressionMutator(loggerMock.Object);
            var context = new MutateIncomingTransportMessageContext(corrupt, headers);

            try
            {
                await mutator.MutateIncoming(context);
            }
            finally
            {
                loggerMock.Verify(l => l.LogError(It.IsAny<int>(), It.Is<string>(m => m.Contains("Some.Type"))), Times.Once());
            }
        }

        private static MutateOutgoingTransportMessageContext CreateOutgoingContext(byte[] body)
        {
            return new MutateOutgoingTransportMessageContext(
                body,
                new object(),
                new Dictionary<string, string> { { "NServiceBus.MessageId", Guid.NewGuid().ToString() } },
                new object(),
                new Dictionary<string, string>());
        }

        private static byte[] Decompress(byte[] zipped)
        {
            using (var gzip = new GZipStream(new MemoryStream(zipped), CompressionMode.Decompress))
            using (var output = new MemoryStream())
            {
                gzip.CopyTo(output);
                return output.ToArray();
            }
        }
    }
}
