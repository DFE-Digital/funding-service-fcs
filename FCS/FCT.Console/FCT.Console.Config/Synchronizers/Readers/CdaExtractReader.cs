namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class CdaExtractReader
    {
        public IReadOnlyCollection<CdaExtractSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private static CdaExtractSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new CdaExtractSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                ExtractName = row.CellStringValue(1, "ExtractName"),
                ArchiveClosedContracts = row.CellBooleanValue(2, "ArchiveClosedContracts"),
                ReportingCloseDate = row.CellNullableDateValue(3, "ReportingCloseDate")
            };
        }
    }
}