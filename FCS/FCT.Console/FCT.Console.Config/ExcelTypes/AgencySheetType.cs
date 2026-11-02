namespace FCT.Console.Config.ExcelTypes
{
    public class AgencySheetType : SheetTypeBase
    {
        public string AgencyCode { get; set; }
        public string AgencyShortCode { get; set; }
        public string Description { get; set; }
        public string ContractReferencePrefix { get; set; }
    }
}
