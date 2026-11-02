namespace FCT.Console.Config.ExcelTypes
{
    public class FundingStreamPeriodCappingPeriodPayCalcPolicySheetType : SheetTypeBase
    {
        public string FundingStreamPeriodCode { get; set; }

        public int CalcPolicyVersion { get; set; }

        public int CappingPeriod { get; set; }

        public decimal OverDeliveryLimit { get; set; }
    }
}