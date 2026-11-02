namespace SFA.FCT.Operations.DataStore.Repositories
{
    using Model;

    public interface IMessageTypeBehaviourRepository
    {
        MessageTypeBehaviour GetBehaviourForMessageType(string messageTypeName);
    }
}
