namespace FCT.Console.Config.ExcelTypes
{
    public class ESFRegionInvestmentPrioritySheetType : SheetTypeBase
    {
        public string RegionType { get; set; }

        public string InvestmentPriorityString { get; set; }

        public decimal InvestmentPriorityDecimal => decimal.Parse(InvestmentPriorityString);

        public string SubnominalCode { get; set; }
    }

}