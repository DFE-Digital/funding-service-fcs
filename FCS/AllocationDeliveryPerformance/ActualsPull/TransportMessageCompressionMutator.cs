namespace ActualsPull
{
    using System;
    using System.IO;
    using System.IO.Compression;
    using System.Threading.Tasks;
    using Extensions;
    using NServiceBus.MessageMutator;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class TransportMessageCompressionMutator : IMutateIncomingTransportMessages, IMutateOutgoingTransportMessages
    {
        private const string IwasCompressedHeaderKey = "IWasCompressed";
        private readonly ILogger _logger;

        public TransportMessageCompressionMutator(ILogger logger)
        {
            _logger = logger;
        }

        public async Task MutateIncoming(MutateIncomingTransportMessageContext context)
        {
            if (!context.Body.IsZipped())
            {
                return;
            }

            try
            {
                using (GZipStream bigStream = new GZipStream(new MemoryStream(context.Body), CompressionMode.Decompress))
                {
                    MemoryStream bigStreamOut = new MemoryStream();
                    await bigStream.CopyToAsync(bigStreamOut).ConfigureAwait(continueOnCapturedContext: false);
                    context.Body = bigStreamOut.ToArray();
                    context.Headers.Remove(IwasCompressedHeaderKey);
                }
            }
            catch (Exception e)
            {
                _logger.LogError(1, $"TransportMessageCompressionMutator {e.Message} - NServiceBus.EnclosedMessageTypes: {context.Headers["NServiceBus.EnclosedMessageTypes"]} " +
                                    $"Body: {System.Text.Encoding.UTF8.GetString(context.Body)}");
                throw;
            }
        }

        public async Task MutateOutgoing(MutateOutgoingTransportMessageContext context)
        {
            const int oneKilobyte = 1024;
            byte[] outgoingBytes = context.OutgoingBody;

            _logger.LogVerbose(1, $"MutateOutgoing OutgoingBody length : {outgoingBytes.Length}");

            if (outgoingBytes?.Length > oneKilobyte)
            {
                MemoryStream memoryStream = new MemoryStream(outgoingBytes);
                MemoryStream outStream = new MemoryStream();

                using (GZipStream tinyStream = new GZipStream(outStream, CompressionMode.Compress))
                {
                    await memoryStream.CopyToAsync(tinyStream).ConfigureAwait(continueOnCapturedContext: false);
                }

                context.OutgoingBody = outStream.ToArray();
                context.OutgoingHeaders[IwasCompressedHeaderKey] = "true";
            }
        }
    }
}
