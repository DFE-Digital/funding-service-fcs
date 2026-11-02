namespace FCT.Console.Config.ExcelTypes
{
    using System;

    public class FundingStreamSheetType : SheetTypeBase
    {
        public string Code { get; set; }
        
        public string Name { get; set; }
        
        public string FinanceShortCode { get; set; }

        public string AgencyCode { get; set; }

        public DateTime? StartDate { get; set; }

        public DateTime? EndDate { get; set; }
    }
}
