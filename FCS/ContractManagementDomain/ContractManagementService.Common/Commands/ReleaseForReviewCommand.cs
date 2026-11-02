namespace SFA.FCT.ContractManagementService.Common.Commands
{
    public class ReleaseForReviewCommand
    {
        public string MasterContractNumber { get; set; }

        public string ContractNumber { get; set; }

        public override string ToString() => $"MasterContractNumber: {MasterContractNumber}, ContractNumber: {ContractNumber}";
    }
}
