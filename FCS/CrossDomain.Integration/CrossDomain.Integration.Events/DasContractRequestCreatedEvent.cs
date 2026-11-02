namespace SFA.FCT.CrossDomain.Integration.Events
{
    public class DasContractRequestCreatedEvent
    {
        public long DasEngagementEventId { get; set; }

        public string ContractNumber { get; set; }
    }
}