namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class AllocationLinesReader
    {
        public IEnumerable<AllocationLinesSheet> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private static AllocationLinesSheet ReadAndTransformRow(WorksheetRowReader row)
        {
            return new AllocationLinesSheet
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                AllocationFundingStreamCode = row.CellStringValue(1, "AllocationFundingStreamCode"),
                AllocationPeriodId = row.CellStringValue(2, "AllocationPeriodId"),
                AllocationFundingLineCode = row.CellStringValue(3, "AllocationFundingLineCode"),
                ProviderCategory = row.CellStringValue(4, "ProviderCategory"),
                FspCode = row.CellStringValue(5, "FspCode"),
                DeliverableCode = row.CellIntValue(6, "DeliverableCode")
            };
        }
    }
}
