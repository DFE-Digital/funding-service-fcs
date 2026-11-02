namespace SFA.FCT.CrossDomain.Integration.Messages.Messages
{
    using Entities.ContractApproval;
    using Entities.CorporateContract;

    public class DocumentMoveResponse
    {
        public bool IsMoveComplete { get; set; }

        public contract CorporateContract { get; set; }

        public string ContractNumberMoved { get; set; }

        public ContractApprovalType ContractApprovalType { get; set; }
    }
}
