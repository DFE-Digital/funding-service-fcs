namespace SFA.FCT.CrossDomain.Integration.Events
{
    public class DraftContractUpdatedEvent : IDraftContractUpdatedEvent
    {
        public string ProcessId { get; set; }
    }
}
