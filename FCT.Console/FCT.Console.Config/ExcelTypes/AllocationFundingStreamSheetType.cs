namespace FCT.Console.Config.ExcelTypes
{
    public class AllocationFundingStreamSheetType : SheetTypeBase
    {
        public string AllocationFundingStreamCode { get; set; }

        public string AllocationPeriodId { get; set; }

        public string FundingTypeCode { get; set; }

        public string FundingPeriodCode { get; set; }

        public string FSPGroupCode { get; set; }
    }
}