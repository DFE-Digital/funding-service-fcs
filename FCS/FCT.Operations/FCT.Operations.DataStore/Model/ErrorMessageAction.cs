namespace SFA.FCT.Operations.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;

    public class ErrorMessageAction
    {
        private ErrorMessageAction()
        {
        }

        public ErrorMessageAction(string messageId, string messageType, string description)
        {
            MessageId = messageId;
            MessageType = messageType;
            Description = description;
        }

        [Key]
        [MaxLength(50)]
        public string MessageId { get; private set; }

        [MaxLength(100)]
        [Required]
        public string MessageType { get; private set; }

        [Required]
        public string Description { get; private set; }

    }
}
