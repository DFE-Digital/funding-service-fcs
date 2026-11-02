namespace SFA.FCT.CrossDomain.Integration.Events
{
    public interface IContractActionRequestedEvent
    {
        Entities.ContractRequest.contractRequestType ContractRequest { get; set; }
    }
}