namespace SFA.FCT.ContractManagementService.Common.Commands
{
    public class ApproveContractClosureCommand
    {
        public string ContractNumber { get; set; }

        public int VersionNumber { get; set; }

        public int SubVersionNumber { get; set; }

        public override string ToString()
        {
            return $"ContractNumber: {ContractNumber}, VersionNumber: {VersionNumber}, SubVersionNumber: {SubVersionNumber}";
        }
    }
}
