namespace FCT.Console.Config.ExcelTypes
{
    using System;

    public class FundingPeriodSheetType : SheetTypeBase
    {
        public string PeriodTypeCode { get; set; }

        public string Period { get; set; }

        public DateTime? StartDate { get; set; }

        public DateTime? EndDate { get; set; }

        /// <summary>
        /// This is the Domain Identifier
        /// </summary>
        public string FundingPeriod { get; set; }

        /// <summary>
        /// CRM uses this as the domain Identifier when it saves the row
        /// </summary>
        public string Key => PeriodTypeCode + Period;
    }
}
