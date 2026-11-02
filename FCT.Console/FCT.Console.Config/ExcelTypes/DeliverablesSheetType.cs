namespace FCT.Console.Config.ExcelTypes
{
    using System;

    public class DeliverablesSheetType : SheetTypeBase
    {
        public string FundingStreamCode { get; set; }

        public int DeliverableCode { get; set; }

        public string BusinessCode { get; set; }

        public string DeliverableName { get; set; }

        public string Status { get; set; }

        public DateTime EffectiveDate { get; set; }
    }

}