namespace SFA.FCT.CrossDomain.Integration.Events
{
    using ContractReq = Entities.ContractRequest;
    using CorpContract = Entities.CorporateContract;

    public class ContractActionRequestedEvent : IContractActionRequestedEvent
    {
        public ContractReq.contractRequestType ContractRequest { get; set; }
    }
}
