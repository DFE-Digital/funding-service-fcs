namespace FundingAllocation.DataStore.Model
{
    public class ProcessedMessage
    {
        private ProcessedMessage()
        {
        }

        public ProcessedMessage(string messageId, string endpoint, string messageType, string businessKey)
        {
            MessageId = messageId;
            Endpoint = endpoint;
            MessageType = messageType;
            BusinessKey = businessKey;
        }
        
        public string MessageId { get; private set; }

        public string Endpoint { get; private set; }
        
        public string MessageType { get; private set; }
        
        public string BusinessKey { get; private set; }
    }
}
