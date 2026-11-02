namespace SFA.FCT.Contracts.AcceptanceTests.Pages.DTO.Levy
{
    using System;

    public class ContractAllocationInfo
    {
        public DateTime? AllocationStartDate { get; set; }

        public DateTime? AllocationEndDate { get; set; }

        public string FundingStreamCode { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        public int Period { get; set; }

        public string PeriodTypeCode { get; set; }
    }
}
