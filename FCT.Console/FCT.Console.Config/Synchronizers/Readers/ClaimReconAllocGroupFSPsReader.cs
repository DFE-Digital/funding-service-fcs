namespace FCT.Console.Config.Synchronizers.Readers
{
    using Excel;
    using ExcelTypes;
    using System.Collections.Generic;
    using System.Linq;

    public class ClaimReconAllocGroupFSPsReader
    {
        public IReadOnlyCollection<ClaimReconAllocGroupFSPSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private ClaimReconAllocGroupFSPSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new ClaimReconAllocGroupFSPSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),

                ClaimReconciliationAllocationGroupCode = row.CellStringValue(1, "ClaimReconciliationAllocationGroupCode"),
                FSPCode = row.CellStringValue(2, "FSPCode")
            };
        }
    }
}
