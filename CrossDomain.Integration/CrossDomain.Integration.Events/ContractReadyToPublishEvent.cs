namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.ContractApproval;
    using Entities.CorporateContract;

    public class ContractReadyToPublishEvent
    {
        public Contract CorporateContract { get; set; }

        public ContractApprovalType ContractApprovalType { get; set; }
    }
}
