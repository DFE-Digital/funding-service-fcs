namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class UnitsOfProcurementReader
    {
        public IReadOnlyCollection<UnitsOfProcurementSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private UnitsOfProcurementSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new UnitsOfProcurementSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                Procurement = row.CellStringValue(1, "Procurement"),
                UoPCode = row.CellStringValue(2, "UoPCode"),
                UoPName = row.CellStringValue(3, "UoPName")
            };
        }
    }
}