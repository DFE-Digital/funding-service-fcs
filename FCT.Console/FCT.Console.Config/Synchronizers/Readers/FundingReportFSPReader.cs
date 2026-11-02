namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class FundingReportFSPReader
    {
        public IReadOnlyCollection<FundingReportFSPSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r =>
                r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private FundingReportFSPSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new FundingReportFSPSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                FundingPeriod = row.CellStringValue(1, "FundingPeriod"),
                Order = row.CellIntValue(2, "Order"),
                FspCode = row.CellStringValue(3, "FspCode"),
                Description = row.CellStringValue(4, "Description")
            };
        }
    }
}
