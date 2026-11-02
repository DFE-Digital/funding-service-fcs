namespace ContractManagementDomain.Endpoint.DeleteContract
{
    public class ContractAttributes
    {
        public ContractAttributes(string ukprn, string fundingType, string period)
        {
            Ukprn = ukprn;
            FundingType = fundingType;
            Period = period;
        }

        public string Ukprn { get; }

        public string FundingType { get; }

        public string Period { get; }
    }
}
