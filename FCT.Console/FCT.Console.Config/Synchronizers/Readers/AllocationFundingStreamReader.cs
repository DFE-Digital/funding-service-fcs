namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class AllocationFundingStreamReader
    {
        public IReadOnlyCollection<AllocationFundingStreamSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private AllocationFundingStreamSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new AllocationFundingStreamSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                AllocationFundingStreamCode = row.CellStringValue(1, "AllocationFundingStreamCode"),
                AllocationPeriodId = row.CellStringValue(2, "AllocationPeriodId"),
                FundingTypeCode = row.CellStringValue(3, "FundingTypeCode"),
                FundingPeriodCode = row.CellStringValue(4, "FundingPeriodCode"),
                FSPGroupCode = row.CellStringValue(5, "FSPGroupCode")
            };
        }
    }
}