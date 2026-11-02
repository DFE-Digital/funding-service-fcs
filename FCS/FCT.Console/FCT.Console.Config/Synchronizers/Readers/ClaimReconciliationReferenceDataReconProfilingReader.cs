namespace FCT.Console.Config.Synchronizers.Readers
{
    using Excel;
    using ExcelTypes;
    using System.Collections.Generic;
    using System.Linq;

    public class ClaimReconciliationReferenceDataReconProfilingReader
    {
        public IReadOnlyCollection<ClaimReconciliationReferenceDataReconProfilingSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => 
                r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private ClaimReconciliationReferenceDataReconProfilingSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new ClaimReconciliationReferenceDataReconProfilingSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                FundingPeriod = row.CellStringValue(1, "FundingPeriod"),
                Ukprn = row.CellIntValue(2, "Ukprn")
            };
        }
    }
}