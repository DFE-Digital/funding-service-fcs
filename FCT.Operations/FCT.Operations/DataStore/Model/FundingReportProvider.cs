namespace FCT.Operations.DataStore.Model
{
    public class FundingReportProvider
    {
        private FundingReportProvider()
        {}

        public FundingReportProvider(int ukprn, string fundingPeriod, string type, int period)
        {
            Ukprn = ukprn;
            FundingPeriod = fundingPeriod;
            Type = type;
            Period = period;
        }

        public int Ukprn { get; private set; }

        public string FundingPeriod { get; private set; }

        public string Type { get; private set; }

        public int Period { get; private set; }
    }
}
