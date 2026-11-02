namespace FCT.Console.Config.ExcelTypes
{
    public class FundingStreamPeriodSubnominalSheetType : SheetTypeBase
    {
        public string FundingStreamPeriodCode { get; set; }

        public int SubnominalCode { get; set; }

        public int? ControlAccountCode { get; set; }
    }
}
