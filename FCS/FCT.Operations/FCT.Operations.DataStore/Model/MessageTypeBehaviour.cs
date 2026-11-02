namespace SFA.FCT.Operations.DataStore.Model
{
    public class MessageTypeBehaviour
    {
        public MessageTypeBehaviour(MessageType messageType, string fullyQualifiedTypeName)
        {
            MessageType = messageType;
            FullyQualifiedTypeName = fullyQualifiedTypeName;
        }

        public MessageType MessageType { get; }

        public string FullyQualifiedTypeName { get; }
    }

    public enum MessageType
    {
        Command,
        Event
    }
}
