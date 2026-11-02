namespace SFA.FCT.ContractManagementService.Common.Commands
{
    public class InitiateContractApprovalCommand
    {
        public string MasterContractNumber { get; set; }

        public string ContractNumber { get; set; }

        public ApprovalRequestSource RequestSource { get; set; }

        public int ContractVersionNumber { get; set; }
    }
}
