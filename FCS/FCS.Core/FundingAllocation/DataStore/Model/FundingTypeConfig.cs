namespace FundingAllocation.DataStore.Model
{
    public class FundingTypeConfig
    {
        private FundingTypeConfig()
        {
        }

        public FundingTypeConfig(string fundingTypeCode, string contractReferencePrefix)
        {
            FundingTypeCode = fundingTypeCode;
            ContractReferencePrefix = contractReferencePrefix;
        }

        public string FundingTypeCode { get; private set; }

        public string ContractReferencePrefix { get; private set; }
    }
}