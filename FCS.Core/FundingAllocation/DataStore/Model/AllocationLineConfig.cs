namespace FundingAllocation.DataStore.Model
{
    public class AllocationLineConfig
    {
        private AllocationLineConfig()
        {
        }

        public AllocationLineConfig(string fundingStreamCode, string periodId, string fundingLineCode, string providerCategory, string fspCode, int deliverableCode)
        {
            FundingStreamCode = fundingStreamCode;
            PeriodId = periodId;
            FundingLineCode = fundingLineCode;
            ProviderCategory = providerCategory;
            FspCode = fspCode;
            DeliverableCode = deliverableCode;
        }

        public string FundingStreamCode { get; private set; }

        public string PeriodId { get; private set; }

        public string FundingLineCode { get; private set; }

        public string ProviderCategory { get; private set; }

        public string FspCode { get; private set; }

        public int DeliverableCode { get; private set; }

        public FspDeliverableConfig FspDeliverableConfig { get; private set; }
    }
}