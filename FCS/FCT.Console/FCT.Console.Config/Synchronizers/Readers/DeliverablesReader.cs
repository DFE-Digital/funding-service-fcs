namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class DeliverablesReader
    {
        public IReadOnlyCollection<DeliverablesSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private DeliverablesSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new DeliverablesSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                FundingStreamCode = row.CellStringValue(1, "FundingStreamCode"),
                DeliverableCode = int.Parse(row.CellStringValue(2, "DeliverableCode")),
                BusinessCode = row.CellStringValue(3, "BusinessCode"),
                DeliverableName = row.CellStringValue(4, "DeliverableName"),
                Status = row.CellStringValue(5, "Status"),
                EffectiveDate = row.CellDateValue(6, "EffectiveDate")
            };
        }
    }
}