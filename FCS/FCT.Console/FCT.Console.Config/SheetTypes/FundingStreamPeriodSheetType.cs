namespace FCT.Console.Config.ExcelTypes
{
    using System;

    public class FundingStreamPeriodSheetType
    {
        public string Code { get; set; }

        public string Name { get; set; }

        public string FundingStreamCode { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public string DummyAccountCode { get; set; }

        public int ControlAccountCode { get; set; }

        public string Element1DefaultValue { get; set; }

        public bool ShouldCreatePaymentFileFlag { get; set; }

        public DateTime CreatedDate { get; set; }
    }
}
