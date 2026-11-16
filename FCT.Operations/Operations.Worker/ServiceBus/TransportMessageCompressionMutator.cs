
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

    public class TransportMessageCompressionMutator :
        IMutateIncomingTransportMessages,
        IMutateOutgoingTransportMessages
    {
        private static readonly int OneKb = 1024;
        private static readonly int AzureServiceBusSizeLimitInKb = 256 * OneKb;
        private static readonly int VeryLargeMessageSize = AzureServiceBusSizeLimitInKb - OneKb;

        private static readonly string VeryLargeMessageHeaderKey = "IAmFcsDataBusMessage";
        private const string IwasCompressedHeaderKey = "IWasCompressed";
        private const string MessageIdHeaderKey = "NServiceBus.MessageId";

        private readonly ILogger _logger;
        private readonly ILargeMessageStorageService _largeMessageStorageService;

        public TransportMessageCompressionMutator(
            ILogger logger,
            ILargeMessageStorageService largeMessageStorageService)
        {
            _logger = logger;
            _largeMessageStorageService = largeMessageStorageService;
        }


        public async Task MutateIncoming(MutateIncomingTransportMessageContext context)
        {
            // ✅ ALWAYS convert first and ONLY use this variable
            byte[] bodyBytes = context.Body.ToArray();

            if (context.Headers.ContainsKey(VeryLargeMessageHeaderKey))
            {
                var messageId = context.Headers[MessageIdHeaderKey];
                _logger.LogInformation(1, $"Very large message incoming: {messageId}");

                var storedBody = _largeMessageStorageService.GetMessageBody(messageId);

                // ✅ Ensure storedBody is byte[]
                context.Body = new ReadOnlyMemory<byte>(storedBody ?? Array.Empty<byte>());

                _logger.LogInformation(1, $"Very large message retrieved: {messageId}");
            }
            else if (bodyBytes != null && bodyBytes.Length > 0 && bodyBytes.IsZipped())
            {
                try
                {
                    using var inputStream = new MemoryStream(bodyBytes);
                    using var outputStream = new MemoryStream();

                    await using (var gzip = new GZipStream(inputStream, CompressionMode.Decompress))
                    {
                        await gzip.CopyToAsync(outputStream).ConfigureAwait(false);
                    }

                    byte[] decompressed = outputStream.ToArray();

                    // ✅ EXPLICIT conversion back
                    context.Body = new ReadOnlyMemory<byte>(decompressed);

                    context.Headers.Remove(IwasCompressedHeaderKey);
                }
                catch (Exception e)
                {
                    _logger.LogError(1,
                        $"TransportMessageCompressionMutator error: {e.Message} - " +
                        $"Type: {context.Headers["NServiceBus.EnclosedMessageTypes"]} " +
                        $"Body: {Encoding.UTF8.GetString(bodyBytes ?? Array.Empty<byte>())}");

                    throw;
                }
            }
        }

        public async Task MutateOutgoing(MutateOutgoingTransportMessageContext context)
        {
            // ✅ FIX HERE
            byte[] outgoingBytes = context.OutgoingBody.ToArray();

            _logger.LogVerbose(1, $"MutateOutgoing OutgoingBody length : {outgoingBytes?.Length}");

            if (outgoingBytes?.Length > VeryLargeMessageSize)
            {
                var messageId = context.OutgoingHeaders[MessageIdHeaderKey];

                _logger.LogInformation(1, $"Very large message outgoing: {messageId}");

                _largeMessageStorageService.StoreMessageBody(messageId, outgoingBytes);

                context.OutgoingBody = Encoding.ASCII.GetBytes("{\"the-body-is-in-blob-storage\":}");
                context.OutgoingHeaders[VeryLargeMessageHeaderKey] = messageId;

                _logger.LogInformation(1, $"Very large message stored: {messageId}");
            }
            else if (outgoingBytes?.Length > OneKb)
            {
                using var memoryStream = new MemoryStream(outgoingBytes);
                using var outStream = new MemoryStream();

                await using (var tinyStream = new GZipStream(outStream, CompressionMode.Compress))
                {
                    await memoryStream.CopyToAsync(tinyStream)
                        .ConfigureAwait(false);
                }

                context.OutgoingBody = outStream.ToArray();
                context.OutgoingHeaders[IwasCompressedHeaderKey] = "true";
            }
        }

    }
}
