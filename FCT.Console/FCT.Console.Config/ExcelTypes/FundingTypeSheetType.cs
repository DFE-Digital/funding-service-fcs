namespace FCT.Console.Config.ExcelTypes
{
    public class FundingTypeSheetType : SheetTypeBase
    {
        public string FundingTypeName { get; set; }
        public string FundingTypeCode { get; set; }
        public int AgencyCode { get; set; }
        public string ContractReferencePrefix { get; set; }
        public bool AllowMultipleContracts { get; set; }
        public bool DocumentationRequired { get; set; }
    }
}
