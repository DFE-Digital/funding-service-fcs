namespace FCT.Operations.DataStore.Model
{
    public class ProcessedMessage
    {
        private ProcessedMessage()
        {
        }

        public ProcessedMessage(string messageId, string processingEndpoint)
        {
            MessageId = messageId;
            ProcessingEndpoint = processingEndpoint;
        }

        public string MessageId { get; private set; }

        public string ProcessingEndpoint { get; private set; }
    }
}