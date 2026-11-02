namespace FCT.Console.Config.Synchronizers.Readers
{
    using Excel;
    using ExcelTypes;
    using System.Collections.Generic;
    using System.Linq;

    public class ClaimCollectionsReader
    {
        public IReadOnlyCollection<ClaimCollectionsSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private ClaimCollectionsSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new ClaimCollectionsSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),

                ClaimCollectionCode = row.CellStringValue(1, "ClaimCollectionCode"),
                ClaimTypeCode = row.CellStringValue(2, "ClaimTypeCode"),
                Period = row.CellStringValue(4, "Period"),
                PeriodType = row.CellStringValue(5, "PeriodType")
            };
        }
    }
}
