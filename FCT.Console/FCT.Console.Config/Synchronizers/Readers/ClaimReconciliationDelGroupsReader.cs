namespace FCT.Console.Config.Synchronizers.Readers
{
    using Excel;
    using ExcelTypes;
    using System.Collections.Generic;
    using System.Linq;

    public class ClaimReconciliationDelGroupsReader
    {
        public IReadOnlyCollection<ClaimReconciliationDelGroupsSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private ClaimReconciliationDelGroupsSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new ClaimReconciliationDelGroupsSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                ClaimReconciliationDeliverableGroupCode = row.CellStringValue(1, "ClaimReconciliationDeliverableGroupCode"),
                ClaimReconciliationDeliverableGroupName = row.CellStringValue(2, "ClaimReconciliationDeliverableGroupName"),
                CapClaimToProfile = row.CellBooleanValue(3, "CapClaimToProfile"),
                ObtainProfileFromReferenceData = row.CellBooleanValue(4, "ObtainProfileFromReferenceData")
            };
        }
    }
}
