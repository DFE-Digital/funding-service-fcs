namespace FCT.Operations.DataStore.Model
{
    public class FundingReportFSP
    {
        private FundingReportFSP()
        {
        }

        public FundingReportFSP(string fspCode, int order, string fundingPeriod, string description)
        {
            FspCode = fspCode;
            Order = order;
            FundingPeriod = fundingPeriod;
            Description = description;
        }

        public string FspCode { get; private set; }

        public int Order { get; private set; }

        public string FundingPeriod { get; private set; }

        public string Description { get; private set; }

        public override string ToString() => $"FspCode: {FspCode}";
    }
}
