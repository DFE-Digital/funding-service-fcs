namespace Operations.Worker.ServiceBus
{
    using System;
    using System.Text;
    using System.IO;
    using System.IO.Compression;
    using System.Threading.Tasks;
    using NServiceBus.MessageMutator;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Storage;

    public class TransportMessageCompressionMutator : IMutateIncomingTransportMessages, IMutateOutgoingTransportMessages
    {
        private static readonly int OneKb = 1024;
        private static readonly int AzureServiceBusSizeLimitInKb = 256 * OneKb;
        private static readonly int VeryLargeMessageSize = AzureServiceBusSizeLimitInKb - OneKb; // 255
        private static readonly string VeryLargeMessageHeaderKey = "IAmFcsDataBusMessage";
        private const string IwasCompressedHeaderKey = "IWasCompressed";
        private const string MessageIdHeaderKey = "NServiceBus.MessageId";
        private readonly ILogger _logger;
        private readonly ILargeMessageStorageService _largeMessageStorageService;

        public TransportMessageCompressionMutator(ILogger logger, ILargeMessageStorageService largeMessageStorageService)
        {
            _logger = logger;
            _largeMessageStorageService = largeMessageStorageService;
        }

        public async Task MutateIncoming(MutateIncomingTransportMessageContext context)
        {
            if (context.Headers.ContainsKey(VeryLargeMessageHeaderKey))
            {
                var messageId = context.Headers[MessageIdHeaderKey];
                _logger.LogInformation(1, $"Very large message incoming: {messageId}");

                context.Body = _largeMessageStorageService.GetMessageBody(messageId);

                _logger.LogInformation(1, $"Very large message retrieved and added to body: {messageId}");
            }
            else if (context.Body.IsZipped())
            {
                try
                {
                    await using GZipStream bigStream = new GZipStream(new MemoryStream(context.Body), CompressionMode.Decompress);
                    MemoryStream bigStreamOut = new MemoryStream();
                    await bigStream.CopyToAsync(bigStreamOut).ConfigureAwait(continueOnCapturedContext: false);
                    context.Body = bigStreamOut.ToArray();
                    context.Headers.Remove(IwasCompressedHeaderKey);
                }
                catch (Exception e)
                {
                    _logger.LogError(1, $"TransportMessageCompressionMutator {e.Message} - NServiceBus.EnclosedMessageTypes: {context.Headers["NServiceBus.EnclosedMessageTypes"]} " +
                                        $"Body: {System.Text.Encoding.UTF8.GetString(context.Body)}");
                    throw;
                }
            }
        }

        public async Task MutateOutgoing(MutateOutgoingTransportMessageContext context)
        {
            byte[] outgoingBytes = context.OutgoingBody;

            _logger.LogVerbose(1, $"MutateOutgoing OutgoingBody length : {outgoingBytes.Length}");

            if (outgoingBytes?.Length > VeryLargeMessageSize)
            {
                var messageId = context.OutgoingHeaders[MessageIdHeaderKey];
                _logger.LogInformation(1, $"Very large message outgoing: {messageId}");

                _largeMessageStorageService.StoreMessageBody(key: messageId, outgoingBytes);
                context.OutgoingBody = Encoding.ASCII.GetBytes("{\"the-body-is-in-blob-storage\":}");
                context.OutgoingHeaders[VeryLargeMessageHeaderKey] = messageId;

                _logger.LogInformation(1, $"Very large message stored: {messageId}");
            }
            else if (outgoingBytes?.Length > OneKb)
            {
                MemoryStream memoryStream = new MemoryStream(outgoingBytes);
                MemoryStream outStream = new MemoryStream();

                await using (GZipStream tinyStream = new GZipStream(outStream, CompressionMode.Compress))
                {
                    await memoryStream.CopyToAsync(tinyStream).ConfigureAwait(continueOnCapturedContext: false);
                }

                context.OutgoingBody = outStream.ToArray();
                context.OutgoingHeaders[IwasCompressedHeaderKey] = "true";
            }
        }
    }
}
