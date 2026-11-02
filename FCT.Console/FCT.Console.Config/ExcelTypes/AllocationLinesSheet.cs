namespace FCT.Console.Config.ExcelTypes
{
    public class AllocationLinesSheet : SheetTypeBase
    {
        public string AllocationFundingStreamCode { get; set; }
        public string AllocationPeriodId { get; set; }
        public string AllocationFundingLineCode { get; set; }
        public string ProviderCategory { get; set; }
        public string FspCode { get; set; }
        public int DeliverableCode { get; set; }
    }
}
