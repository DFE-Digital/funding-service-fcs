namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class LaFundingReportProviderReader
    {
        public IReadOnlyCollection<LaFundingReportProviderSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r =>
                r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private LaFundingReportProviderSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new LaFundingReportProviderSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                FundingPeriod = row.CellStringValue(1, "FundingPeriod"),
                Ukprn = row.CellIntValue(2, "Ukprn"),
                Type = row.CellStringValue(3, "Type"),
                Period = row.CellIntValue(5, "Period")
            };
        }
    }
}
