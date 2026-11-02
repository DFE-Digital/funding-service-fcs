namespace FundingAllocation.DataStore.Model
{
    public class ProviderCategoryException
    {
        private ProviderCategoryException()
        {
        }

        public ProviderCategoryException(string fundingTypeCode, string fundingPeriodCode, string ukprn, string category)
        {
            FundingTypeCode = fundingTypeCode;
            FundingPeriodCode = fundingPeriodCode;
            UKPRN = ukprn;
            Category = category;
        }

        public string FundingTypeCode { get; private set; }

        public string FundingPeriodCode { get; private set; }

        public string UKPRN { get; private set; }

        public string Category { get; private set; }
    }
}
