namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    using Entities.CorporateContract;
    using Entities.ContractApproval;

    public class DocumentMoveCommand
    {
        public contract CorporateContract { get; set; }

        public string ContractNumberToBeMoved { get; set; }

        public ContractApprovalType ContractApprovalType { get; set; }
    }
}
