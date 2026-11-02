namespace FCT.Console.Config.ExcelTypes
{
    public class FundingStreamPeriodPayCalcPolicySheetType : SheetTypeBase
    {
        public string FundingStreamPeriodCode { get; set; }

        public int CalcPolicyVersion { get; set; }

        public string PaymentCappingPeriod { get; set; }
    }
}
