namespace FCT.Operations.FundingConfirmationReport.DTOs
{
    public class UkprnInfo
    {
        public UkprnInfo(int ukprn, string type, string name)
        {
            Ukprn = ukprn;
            Type = type;
            Name = name;
        }

        public int Ukprn { get; }
        public string Type { get; }
        public string Name { get; }
    }
}
