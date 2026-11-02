namespace SFA.FCT.ContractManagementService.Common.Commands
{
    public class CancelContractTerminationCommand
    {
        public string ContractNumber { get; set; }

        public int VersionNumber { get; set; }

        public int SubVersionNumber { get; set; }

        public override string ToString()
        {
            return $"ContractNumber: {ContractNumber}, VersionNumber: {VersionNumber}, SubVersionNumber: {SubVersionNumber}";
        }

        public ContractIdentifier GetContractIdentifier()
        {
            return new ContractIdentifier(ContractNumber, VersionNumber, SubVersionNumber);
        }
    }
}