namespace Datafix.Tests.Automation.Releases.R77.Audit
{
    using System;
    public class FcsMessage
    {
        public FcsMessage(byte[] messageBytes, string messageType, DateTime sentTime, Guid messageId, string originatingEndpoint, string processingEndpoint, string businessKey, byte[] propertiesBytes)
        {
            MessageBytes = messageBytes;
            MessageType = messageType;
            SentTime = sentTime;
            MessageId = messageId;
            OriginatingEndpoint = originatingEndpoint;
            ProcessingEndpoint = processingEndpoint;
            BusinessKey = businessKey;
            PropertiesBytes = propertiesBytes;
        }

        public byte[] MessageBytes { get; }

        public byte[] PropertiesBytes { get; }
        /// <summary>
        /// this is a a fully qualified type name
        /// </summary>
        public string MessageType { get; }

        public DateTime SentTime { get; }

        public Guid MessageId { get; }

        public string OriginatingEndpoint { get; }

        public string ProcessingEndpoint { get; }

        public string BusinessKey { get; }
    }
}
