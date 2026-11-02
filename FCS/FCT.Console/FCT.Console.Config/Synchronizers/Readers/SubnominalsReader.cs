namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class SubnominalsReader
    {
        public IReadOnlyCollection<SubnominalsSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private SubnominalsSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new SubnominalsSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                SubnominalCode = row.CellStringValue(1, "SubnominalCode"),
                ShortDescription = row.CellStringValue(2, "ShortDescription")
            };
        }
    }
}