namespace SFA.FCT.Operations.Common.Commands
{
    public class MessageReplayCommand
    {
        public string MessageId { get; set; }

        public string Description { get; set; }

        public override string ToString()
        {
            return $"MessageId: {MessageId}, Description: {Description}";
        }
    }
}