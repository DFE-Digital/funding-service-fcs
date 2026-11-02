namespace FCT.Console.Config.ExcelTypes
{
    public class FundingStreamPeriodCappingGroupSheetType : SheetTypeBase
    {
        public string FundingStreamPeriod { get; set; }
        public string CappingGroupName { get; set; }
        public bool AllowUnderDeliveryToBeReUsed { get; set; }
        public bool AllowOverDeliveryToBeOffset { get; set; }
        public int FundingStreamPeriodCappingGroupId { get; set; }

        public string Name => $"{FundingStreamPeriod} ({CappingGroupName})";
    }
}
