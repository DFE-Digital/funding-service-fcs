namespace SFA.FCT.Contracts.AcceptanceTests.Pages.DTO
{
    using System;

    public class SimpleContractHeader
    {
        public string MasterContractNumber { get; set; }

        public string ContractNumber { get; set; }

        public int ContractVersionNumber { get; set; }

        public string Ukprn { get; set; }

        public DateTime ContractStartDate { get; set; }

        public DateTime ContractEndDate { get; set; }

        public decimal ContractValue { get; set; }

        public string ContractType { get; set; }

        public int ContractPeriod { get; set; }
    }
}
