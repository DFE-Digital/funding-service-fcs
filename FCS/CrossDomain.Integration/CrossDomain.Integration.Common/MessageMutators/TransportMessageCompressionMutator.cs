namespace SFA.FCT.CrossDomain.Integration.Common.MessageMutators
{
    using System.IO;
    using System.IO.Compression;
    using System.Text;
    using NServiceBus;
    using NServiceBus.Logging;
    using NServiceBus.MessageMutator;
    using NServiceBus.Unicast.Messages;
    using Repositories;

    public class TransportMessageCompressionMutator : IMutateTransportMessages
    {
        private static readonly int OneKb = 1024;
        private static readonly int AzureServiceBusSizeLimitInKb = 256 * OneKb;
        private static readonly int VeryLargeMessageSize = AzureServiceBusSizeLimitInKb - OneKb; // 255Kb
        private static readonly string VeryLargeMessageHeaderKey = "IAmFcsDataBusMessage";
        private static readonly ILog Logger = LogManager.GetLogger("TransportMessageCompressionMutator");

        public void MutateOutgoing(LogicalMessage message, TransportMessage transportMessage)
        {
            // there are many small messages that don't need compression and don't merit the overheads.
            if (transportMessage.Body.Length > VeryLargeMessageSize)
            { 
                LargeMessageRepository.StoreMessageBody(key: transportMessage.Id, transportMessage.Body);

                transportMessage.Body = Encoding.ASCII.GetBytes("{\"the-body-is-in-blob-storage\":}");

                transportMessage.Headers[VeryLargeMessageHeaderKey] = transportMessage.Id;
            }
            else if (transportMessage.Body.Length > OneKb)
            {
                Logger.Debug("transportMessage.Body size before compression: " + transportMessage.Body.Length);

                MemoryStream memoryStream = new MemoryStream(transportMessage.Body);
                MemoryStream outStream = new MemoryStream();

                using (GZipStream tinyStream = new GZipStream(outStream, CompressionMode.Compress))
                {
                    memoryStream.CopyTo(tinyStream);
                }

                // copy the compressed buffer only after the GZipStream is disposed, 
                // otherwise, not all the compressed message will be copied.
                transportMessage.Body = outStream.ToArray();
                transportMessage.Headers["IWasCompressed"] = "true";
                Logger.Debug("transportMessage.Body size after compression: " + transportMessage.Body.Length);
            }
        }

        public void MutateIncoming(TransportMessage transportMessage)
        {
            if (transportMessage.Headers.ContainsKey("IWasCompressed"))
            {
                using (GZipStream bigStream = new GZipStream(new MemoryStream(transportMessage.Body), CompressionMode.Decompress))
                {
                    MemoryStream bigStreamOut = new MemoryStream();
                    bigStream.CopyTo(bigStreamOut);
                    transportMessage.Body = bigStreamOut.ToArray();
                }
            }
            else if (transportMessage.Headers.ContainsKey(VeryLargeMessageHeaderKey))
            {
                var key = transportMessage.Headers[VeryLargeMessageHeaderKey];

                transportMessage.Body = LargeMessageRepository.GetMessageBody(key);
            }
        }
    }
}