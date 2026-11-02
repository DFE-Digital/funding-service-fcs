namespace FundingAllocation.DataStore.Model
{
    using System;

    public class FundingStreamPeriodConfig
    {
        public FundingStreamPeriodConfig(
            string fundingStreamPeriodCode,
            string fundingStreamCode,
            string allocationReferencePrefix,
            DateTime startDate,
            DateTime endDate)
        {
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            FundingStreamCode = fundingStreamCode;
            AllocationReferencePrefix = allocationReferencePrefix;
            StartDate = startDate;
            EndDate = endDate;
        }

        public string FundingStreamPeriodCode { get; private set; }
        public string FundingStreamCode { get; private set; }
        public string AllocationReferencePrefix { get; private set; }
        public DateTime StartDate { get; private set; }
        public DateTime EndDate { get; private set; }

        public override string ToString() => $"FundingStreamPeriodCode: {FundingStreamPeriodCode}";
    }
}