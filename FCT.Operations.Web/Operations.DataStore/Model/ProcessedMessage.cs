namespace Operations.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

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

        [Key, Column(Order = 0), MaxLength(36)]
        public string MessageId { get; private set; }

        [Key, Column(Order = 1), MaxLength(100)]
        public string ProcessingEndpoint { get; private set; }
    }
}
