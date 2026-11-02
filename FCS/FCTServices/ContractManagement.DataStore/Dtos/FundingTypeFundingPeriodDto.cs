namespace ContractManagement.DataStore.Dtos
{
    public class FundingTypeFundingPeriodDto
    {
        public FundingTypeFundingPeriodDto(string fundingType, string fundingPeriod)
        {
            FundingType = fundingType;
            FundingPeriod = fundingPeriod;
        }

        public string FundingType { get; }

        public string FundingPeriod { get; }
    }
}
