namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class AllocationProviderTypesReader
    {
        public IEnumerable<AllocationProviderTypeSheet> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private static AllocationProviderTypeSheet ReadAndTransformRow(WorksheetRowReader row)
        {
            return new AllocationProviderTypeSheet
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                ProviderType = row.CellStringValue(1, "ProviderType"),
                ProviderSubType = row.CellStringValue(2, "ProviderSubType"),
                ProviderCategory = row.CellStringValue(3, "ProviderCategory"),
            };
        }
    }
}
