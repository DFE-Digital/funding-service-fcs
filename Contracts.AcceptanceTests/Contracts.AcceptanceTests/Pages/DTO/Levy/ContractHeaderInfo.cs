namespace SFA.FCT.Contracts.AcceptanceTests.Pages.DTO.Levy
{
    using System;

    public class ContractHeaderInfo
    {
        public DateTime? ContractStartDate { get; set; }

        public DateTime? ContractEndDate { get; set; }

        public decimal ContractValue { get; set; }

        public string ContractType { get; set; }

        public int Ukprn { get; set; }

        public string LegalName { get; set; }

        public string OrganisationId { get; set; }

        public string FundingTypeCode { get; set; }

        public string PeriodTypeCode { get; set; }

        public int Period { get; set; }
    }
}
