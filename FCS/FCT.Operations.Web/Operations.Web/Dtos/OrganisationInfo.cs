namespace Operations.Web.Dtos
{
    public class OrganisationInfo
    {
        public OrganisationInfo(string ukprn, string tradingName)
        {
            Ukprn = ukprn;
            TradingName = tradingName;
        }

        public string Ukprn { get; }

        public string TradingName { get; }
    }
}