namespace SFA.FCT.Operations.Common.DTOs
{
    public class MessageDetail
    {
        public MessageDetail(string messageId, string messageType, string messageBody, string endpointName)
        {
            MessageId = messageId;
            MessageType = messageType;
            MessageBody = messageBody;
            EndpointName = endpointName;
        }

        public string MessageId { get; }

        public string MessageType { get; }

        public string MessageBody { get; }

        public string EndpointName { get; }
    }
}
