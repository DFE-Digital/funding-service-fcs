namespace FCT.Operations.DataStore.Model
{
    public class FundingStreamPeriod
    {
        private FundingStreamPeriod()
        {}

        public FundingStreamPeriod(string fundingStreamPeriodCode, string periodTypeCode)
        {
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            PeriodTypeCode = periodTypeCode;
        }

        public string FundingStreamPeriodCode { get; private set; }
        
        public string PeriodTypeCode { get; private set; }
    }
}
