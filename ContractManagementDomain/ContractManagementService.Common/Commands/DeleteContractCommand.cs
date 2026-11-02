namespace SFA.FCT.ContractManagementService.Common.Commands
{
    public class DeleteContractCommand
    {
        public string ContractNumber { get; set; }

        public int VersionNumber { get; set; }

        public override string ToString()
        {
            return $"ContractNumber: {ContractNumber}, VersionNumber: {VersionNumber}";
        }
    }
}
