namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class FundingPeriodSheetTypeReader
    {
        public IEnumerable<FundingPeriodSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private FundingPeriodSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new FundingPeriodSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                PeriodTypeCode = row.CellStringValue(1, "PeriodTypeCode"),
                Period = row.CellStringValue(2, "Period"),
                StartDate = row.CellDateValue(3, "StartDate"),
                EndDate = row.CellDateValue(4, "EndDate"),
            };
        }
    }
}
