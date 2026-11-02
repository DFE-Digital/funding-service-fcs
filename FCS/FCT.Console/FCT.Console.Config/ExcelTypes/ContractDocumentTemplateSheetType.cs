namespace FCT.Console.Config.ExcelTypes
{
    public class ContractDocumentTemplateSheetType : SheetTypeBase    
    {
        public string FundingTypeCode { get; set; }

        public string FundingPeriodCode { get; set; }

        public string DocumentComponentCode { get; set; }

        public string ContractType { get; set; }

        public string Template { get; set; }
    }
}
