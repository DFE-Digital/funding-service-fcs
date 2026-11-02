namespace SFA.FCT.ContractManagementService.Common.Commands
{
    public class PublishApprovedContractCommand
    {
        public string MasterContractNumber { get; set; }

        public string ContractNumber { get; set; }

        public override string ToString()
        {
            return $"Master Contract: {MasterContractNumber}, Contract: {ContractNumber}";
        }
    }
}
