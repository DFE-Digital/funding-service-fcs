namespace FCT.Console.Config.Synchronizers.Readers
{
    using Excel;
    using ExcelTypes;
    using System.Collections.Generic;
    using System.Linq;

    public class ClaimTypeReader
    {
        public IReadOnlyCollection<ClaimTypeSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private ClaimTypeSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new ClaimTypeSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                ClaimTypeCode = row.CellStringValue(1, "ClaimTypeCode"),
                Name = row.CellStringValue(2, "Name")
            };
        }
    }
}
