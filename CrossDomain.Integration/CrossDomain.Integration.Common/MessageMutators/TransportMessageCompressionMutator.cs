namespace SFA.FCT.CrossDomain.Integration.Common.MessageMutators
{
    using System;
    using System.IO;
    using System.IO.Compression;
    using System.Text;
    using System.Threading.Tasks;
    using NServiceBus;
    using NServiceBus.Logging;
    using NServiceBus.MessageMutator;
    using SFA.FCT.CrossDomain.Integration.Common.Repositories;

    public class TransportMessageCompressionMutator : IMutateOutgoingTransportMessages, IMutateIncomingTransportMessages
    {
        private static readonly int OneKb = 1024;
        private static readonly int AzureServiceBusSizeLimitInKb = 256 * OneKb;
        private static readonly int VeryLargeMessageSize = AzureServiceBusSizeLimitInKb - OneKb;
        private static readonly string VeryLargeMessageHeaderKey = "IAmFcsDataBusMessage";
        private static readonly ILog Logger = LogManager.GetLogger("TransportMessageCompressionMutator");

        public Task MutateOutgoing(MutateOutgoingTransportMessageContext context)
        {
            var body = context.OutgoingBody.ToArray();
            var headers = context.OutgoingHeaders;

            if (body.Length > VeryLargeMessageSize)
            {
                var messageId = headers.TryGetValue(Headers.MessageId, out var id) ? id : Guid.NewGuid().ToString();
                LargeMessageRepository.StoreMessageBody(messageId, body);
                context.OutgoingBody = Encoding.ASCII.GetBytes("{\"the-body-is-in-blob-storage\":}");
                headers[VeryLargeMessageHeaderKey] = messageId;
            }
            else if (body.Length > OneKb)
            {
                Logger.Debug($"Body size before compression: {body.Length}");

                using var memoryStream = new MemoryStream(body);
                using var outStream = new MemoryStream();
                using (var gzip = new GZipStream(outStream, CompressionMode.Compress))
                {
                    memoryStream.CopyTo(gzip);
                }

                context.OutgoingBody = outStream.ToArray();
                headers["IWasCompressed"] = "true";

                Logger.Debug($"Body size after compression: {context.OutgoingBody.Length}");
            }

            return Task.CompletedTask;
        }

        public Task MutateIncoming(MutateIncomingTransportMessageContext context)
        {
            var headers = context.Headers;

            if (headers.ContainsKey("IWasCompressed"))
            {
                using var gzip = new GZipStream(new MemoryStream(context.Body.ToArray()), CompressionMode.Decompress);
                using var outStream = new MemoryStream();
                gzip.CopyTo(outStream);
                context.Body = outStream.ToArray();
            }
            else if (headers.TryGetValue(VeryLargeMessageHeaderKey, out var key))
            {
                context.Body = LargeMessageRepository.GetMessageBody(key);
            }

            return Task.CompletedTask;
        }
    }
}
