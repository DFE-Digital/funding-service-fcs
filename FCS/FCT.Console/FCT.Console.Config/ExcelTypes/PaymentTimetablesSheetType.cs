namespace FCT.Console.Config.ExcelTypes
{
    using System;

    public class PaymentTimetablesSheetType : SheetTypeBase
    {
        public string FundingStreamPeriodCode { get; set; }
        public string CalendarPeriod { get; set; }
        public string CalendarPeriodType { get; set; }
        public string FinancialPeriod { get; set; }
        public string FinancialPeriodType { get; set; }
        public DateTime PeriodStartDate { get; set; }
        public DateTime PeriodEndDate { get; set; }
        public DateTime CensusEndDate { get; set; }
        public DateTime? DueDate { get; set; }
        public string LinkCodeSuffix { get; set; }
        public string Status { get; set; }
        public int? PayCalcPolicyVersion { get; set; }
    }
}
