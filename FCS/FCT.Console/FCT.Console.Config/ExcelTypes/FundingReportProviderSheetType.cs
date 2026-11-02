namespace FCT.Console.Config.ExcelTypes
{
    public class FundingReportProviderSheetType : SheetTypeBase
    {
        public string FundingPeriod { get; set; }
        public int Ukprn { get; set; }
        public string Type { get; set; }
        public int Period { get; set; }

        public override bool Equals(object obj)
        {
            if (obj is FundingReportProviderSheetType other)
            {
                return FundingPeriod == other.FundingPeriod &&
                       Ukprn == other.Ukprn &&
                       Type == other.Type &&
                       Period == other.Period;
            }

            return false;
        }

        public override int GetHashCode()
        {
            return FundingPeriod.GetHashCode() ^
                   Ukprn.GetHashCode() ^
                   Type.GetHashCode() ^
                   Period.GetHashCode();
        }
    }
}
