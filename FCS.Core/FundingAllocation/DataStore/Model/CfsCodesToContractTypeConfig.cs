namespace FundingAllocation.DataStore.Model
{
    public class CfsCodesToContractTypeConfig
    {
        // This relates to PC-CT tab in config workbook

        private CfsCodesToContractTypeConfig()
        {
        }

        public CfsCodesToContractTypeConfig(string fundingTypeCode, string fundingPeriodCode, string providerCategory, string contractType)
        {
            FundingTypeCode = fundingTypeCode;
            FundingPeriodCode = fundingPeriodCode;
            ProviderCategory = providerCategory;
            ContractType = contractType;
        }

        public string FundingTypeCode { get; private set; }

        public string FundingPeriodCode { get; private set; }

        public string ProviderCategory { get; private set; }

        public string ContractType { get; private set; }
    }
}