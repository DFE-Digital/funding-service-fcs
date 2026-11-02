namespace FCT.Console.Config.ExcelTypes
{
    public class FundingReportFSPSheetType : SheetTypeBase
    {
        public string FundingPeriod { get; set; }
        public int Order { get; set; }
        public string FspCode { get; set; }
        public string Description { get; set; }

        public override bool Equals(object obj)
        {
            if (obj is FundingReportFSPSheetType other)
            {
                return FundingPeriod == other.FundingPeriod &&
                       Order == other.Order &&
                       FspCode == other.FspCode &&
                       Description == other.Description;
            }

            return false;
        }

        public override int GetHashCode()
        {
            return FundingPeriod.GetHashCode() ^
                   Order.GetHashCode() ^
                   FspCode.GetHashCode() ^
                   Description.GetHashCode();
        }
    }
}
