namespace FCT.Console.Config.Synchronizers.Readers
{
    using Excel;
    using ExcelTypes;
    using System.Collections.Generic;
    using System.Linq;

    public class ClaimReconciliationReferenceDataProfilesReader
    {
        public IReadOnlyCollection<ClaimReconciliationReferenceDataProfileSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private ClaimReconciliationReferenceDataProfileSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new ClaimReconciliationReferenceDataProfileSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                ClaimReconciliationDeliverableGroupCode = row.CellStringValue(1, "ClaimReconciliationDeliverableGroupCode"),
                Ukprn = int.Parse(row.CellStringValue(2, "Ukprn")),
                PlannedValue = row.CellCurrencyValue(3, "PlannedValue")
            };
        }
    }
}
