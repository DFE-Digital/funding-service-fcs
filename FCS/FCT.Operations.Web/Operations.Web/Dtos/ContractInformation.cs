namespace Operations.Web.Dtos
{
    public class ContractInformation
    {
        public ContractInformation()
        {
        }

        public ContractInformation(string contractNumber, string masterContractNumber,
            int contractVersionNumber, int subVersionNumber, string ukprn, string contractStatus, string contractSubStatus)
        {
            ContractNumber = contractNumber;
            MasterContractNumber = masterContractNumber;
            Ukprn = ukprn;
            ContractVersionNumber = contractVersionNumber;
            ContractStatus = contractStatus;
            ContractSubStatus = contractSubStatus;
            SubVersionNumber = subVersionNumber;
        }

        public string ContractNumber { get; set; }

        public string MasterContractNumber { get; set; }

        public string Ukprn { get; set; }

        public int SubVersionNumber { get; set; }

        public int ContractVersionNumber { get; set; }

        public string ContractStatus { get; set; }

        public string ContractSubStatus { get; set; }

        public override string ToString()
        {
            return
                $"ContractNumber: {ContractNumber}, MasterContractNumber: {MasterContractNumber}, Ukprn: {Ukprn}, ContractVersionNumber: {ContractVersionNumber},  SubVersionNumber: {SubVersionNumber}, ContractStatus: {ContractStatus}, ContractSubStatus: {ContractSubStatus}";
        }
    }
}