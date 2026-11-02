namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class FundingReportProviderReader
    {
        public IReadOnlyCollection<FundingReportProviderSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r =>
                r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private FundingReportProviderSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new FundingReportProviderSheetType
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
