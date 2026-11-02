namespace FundingAllocation.DataStore.Model
{
    public class AllocationFundingStreamConfig
    {
        private AllocationFundingStreamConfig()
        {
        }

        public AllocationFundingStreamConfig(string allocationFundingStreamCode, string allocationPeriodId, string fundingTypeCode, string fundingPeriodCode, string fspGroupCode)
        {
            AllocationFundingStreamCode = allocationFundingStreamCode;
            AllocationPeriodId = allocationPeriodId;
            FundingTypeCode = fundingTypeCode;
            FundingPeriodCode = fundingPeriodCode;
            FSPGroupCode = fspGroupCode;
        }

        public string AllocationFundingStreamCode { get; private set; }

        public string AllocationPeriodId { get; private set; }

        public string FundingTypeCode { get; private set; }

        public string FundingPeriodCode { get; private set; }

        public string FSPGroupCode { get; private set; }
    }
}