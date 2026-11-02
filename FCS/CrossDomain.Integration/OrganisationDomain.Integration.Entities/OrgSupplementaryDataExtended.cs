namespace OrganisationDomain.Integration.Entities
{
    public class OrgSupplementaryDataExtended : OrgSupplementaryData
    {
        public OrgSupplementaryDataExtended(int ukprn, string companyNumber, string charityNumber, string tradingName, OrgSupplementaryAddress address) 
            : base(ukprn, companyNumber, charityNumber, address)
        {
            TradingName = tradingName;
        }

        public string TradingName { get; }
    }
}