namespace SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.Infos
{
    using System;

    public class AllocationInfo
    {
        public AllocationInfo()
        {
        }

        public AllocationInfo(string allocationNumber, decimal? reconciliationValue, DateTime startDate, DateTime endDate, string fundingStreamPeriodCode)
        {
            AllocationNumber = allocationNumber;
            ReconciliationValue = reconciliationValue;
            StartDate = startDate;
            EndDate = endDate;
            FundingStreamPeriodCode = fundingStreamPeriodCode;
        }

        public string AllocationNumber { get; set; }

        public decimal? ReconciliationValue { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }
    }
}
