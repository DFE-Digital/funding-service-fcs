namespace FCT.Operations.Cda.Dtos
{
    public class CdaReportFundingStreamPeriod
    {
        public CdaReportFundingStreamPeriod(string extractName, string fundingStreamPeriodCode)
        {
            ExtractName = extractName;
            FundingStreamPeriodCode = fundingStreamPeriodCode;
        }

        public string ExtractName { get; private set; }
        public string FundingStreamPeriodCode { get; private set; }
    }
}
