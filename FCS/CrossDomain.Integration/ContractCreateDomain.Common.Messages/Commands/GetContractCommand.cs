namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Commands
{
    public class GetContractCommand
    {
        public string ProcessId { get; set; }

        public string MasterContractNumber { get; set; }

        public string ContractNumber { get; set; }

        public string Ukprn { get; set; }
    }
}
