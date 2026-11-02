namespace FCT.Console.Config.ExcelTypes
{
    public class FTPCoTSheetType : SheetTypeBase
    {
        public string FundingTypeCode { get; set; }

        public string FundingPeriodCode { get; set; }

        public string ContractType { get; set; }

        public string DefinedContractTermForProvider { get; set; }
    }
}