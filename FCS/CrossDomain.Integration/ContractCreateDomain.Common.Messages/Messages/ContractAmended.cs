namespace SFA.FCT.ContractCreateDomain.Common.Messages.Messages
{
    public class ContractAmended
    {
        public string ProcessId { get; set; }

        public string MasterContractNumber { get; set; }

        public string ContractNumber { get; set; }

        public int ContractVersionNumber { get; set; }

        public int ContractSubVersionNumber { get; set; }

        public int Ukprn { get; set; }

        public string AmendmentType { get; set; }

        public override string ToString()
        {
            return
                $"MasterContractNumber: {MasterContractNumber}, " +
                $"ContractNumber: {ContractNumber}, " +
                $"ContractVersionNumber: {ContractVersionNumber}, " +
                $"ContractSubVersionNumber: {ContractSubVersionNumber}, " +
                $"Ukprn: {Ukprn}," +
                $"AmendmentType: {AmendmentType}";
        }
    }
}
