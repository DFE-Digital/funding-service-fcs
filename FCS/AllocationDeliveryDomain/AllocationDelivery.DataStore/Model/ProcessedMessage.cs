namespace SFA.FCT.AllocationDelivery.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;

    public class ProcessedMessage
    {
        private ProcessedMessage()
        {

        }

        public ProcessedMessage(string messageId)
        {
            MessageId = messageId;
        }

        [Key]
        [MaxLength(36)]
        public string MessageId { get; private set; }
    }
}