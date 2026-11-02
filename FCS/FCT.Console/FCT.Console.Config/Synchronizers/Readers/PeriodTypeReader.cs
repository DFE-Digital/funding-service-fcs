namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class PeriodTypeReader
    {
        public IReadOnlyCollection<PeriodTypeSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private PeriodTypeSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new PeriodTypeSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                PeriodTypeCode = row.CellStringValue(1, "PeriodTypeCode"),
                PeriodTypeName = row.CellStringValue(2, "PeriodTypeName"),
            };
        }
    }
}
