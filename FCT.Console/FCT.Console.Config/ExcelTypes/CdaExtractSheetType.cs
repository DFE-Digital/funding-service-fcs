namespace FCT.Console.Config.ExcelTypes
{
    using System;

    public class CdaExtractSheetType : SheetTypeBase
    {
        public string ExtractName { get; set; }

        public bool ArchiveClosedContracts { get; set; }

        public DateTime? ReportingCloseDate { get; set; }
    }
}