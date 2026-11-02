namespace ContractCreateDomain.Endpoint.NonFinancialAmendment.Dtos
{
    public class FundingTypeFundingPeriodKey
    {
        public FundingTypeFundingPeriodKey(string fundingTypeCode, string fundingPeriodName)
        {
            FundingTypeCode = fundingTypeCode;
            FundingPeriodName = fundingPeriodName;
        }

        public string FundingTypeCode { get; }

        public string FundingPeriodName { get; }
    }
}