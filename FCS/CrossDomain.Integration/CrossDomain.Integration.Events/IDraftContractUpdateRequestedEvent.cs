namespace SFA.FCT.CrossDomain.Integration.Events
{
    public interface IDraftContractUpdateRequestedEvent : IContractActionRequestedEvent
    {
        string ProcessId { get; set; }
    }
}
