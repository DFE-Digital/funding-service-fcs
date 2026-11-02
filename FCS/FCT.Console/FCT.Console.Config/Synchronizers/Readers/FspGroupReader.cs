namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class FspGroupReader
    {
        public IEnumerable<FspGroupSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private FspGroupSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new FspGroupSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                FSPGroupCode = row.CellStringValue(1, "FSPGroupCode").Trim(),
                ContractDocumentDisplayName = row.CellStringValue(2, "ContractDocumentDisplayName").Trim(),
                DisplayOrder = row.CellIntValue(3, "DisplayOrder")
            };
        }
    }
}
