namespace SFA.FCT.ContractManagementService.Common.Commands
{
    public class ApproveContractTerminationInitiationCommand
    {
        public string ContractNumber { get; set; }

        public int VersionNumber { get; set; }

        public int SubVersionNumber { get; set; }

        public bool ShouldInitiateAmendmentOnApproval { get; set; }

        public override string ToString()
        {
            return $"ContractNumber: {ContractNumber}, VersionNumber: {VersionNumber}, SubVersionNumber: {SubVersionNumber}, ShouldInitiateAmendmentOnApproval: {ShouldInitiateAmendmentOnApproval}";
        }

        public ContractIdentifier GetContractIdentifier()
        {
            return new ContractIdentifier(ContractNumber, VersionNumber, SubVersionNumber);
        }
    }
}