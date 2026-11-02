namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class FundingTypePeriodFundingStreamPeriodReader
    {
        public IReadOnlyCollection<FundingTypePeriodFundingStreamPeriodSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private FundingTypePeriodFundingStreamPeriodSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new FundingTypePeriodFundingStreamPeriodSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                FundingTypeCode = row.CellStringValue(1, "FundingTypeCode"),
                FundingPeriodCode = row.CellStringValue(2, "FundingPeriodCode"),
                FundingStreamCode = row.CellStringValue(3, "FundingStreamCode")
            };
        }
    }
}