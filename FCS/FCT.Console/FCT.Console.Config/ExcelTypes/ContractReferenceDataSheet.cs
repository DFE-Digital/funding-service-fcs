namespace FCT.Console.Config.ExcelTypes
{
    public class ContractReferenceDataSheet : SheetTypeBase
    {
        public int Ukprn { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        public decimal FinancialEnvelope1Funding { get; set; }

        public decimal FinancialEnvelope2Funding { get; set; }
    }
}