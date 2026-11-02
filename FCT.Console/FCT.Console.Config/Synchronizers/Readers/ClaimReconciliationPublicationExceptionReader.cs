namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class ClaimReconciliationPublicationExceptionReader
    {
        public IReadOnlyCollection<ClaimReconciliationPublicationExceptionSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private static ClaimReconciliationPublicationExceptionSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new ClaimReconciliationPublicationExceptionSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                ClaimReconciliationAllocationGroupCode = row.CellStringValue(1, "ClaimReconciliationAllocationGroupCode"),
                Ukprn = row.CellIntValue(2, "Ukprn")
            };
        }
    }
}