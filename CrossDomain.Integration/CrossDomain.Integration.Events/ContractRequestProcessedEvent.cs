namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.ContractRequest;

    public class ContractRequestProcessedEvent
    {
        public contractRequestType ContractRequest { get; set; }
    }
}
