namespace FCT.Console.Config.Synchronizers.Readers
{
    using Excel;
    using ExcelTypes;
    using System.Collections.Generic;
    using System.Linq;

    public class ClaimReconciliationAllocationGroupReader
    {
        public IReadOnlyCollection<ClaimReconciliationAllocationGroupSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private ClaimReconciliationAllocationGroupSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new ClaimReconciliationAllocationGroupSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                ClaimReconciliationAllocationGroupCode = row.CellStringValue(1, "ClaimReconciliationAllocationGroupCode"),
                GroupName = row.CellStringValue(2, "GroupName")
            };
        }
    }
}
