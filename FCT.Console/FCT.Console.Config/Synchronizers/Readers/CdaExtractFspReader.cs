namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class CdaExtractFspReader
    {
        public IReadOnlyCollection<CdaExtractFspSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private CdaExtractFspSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new CdaExtractFspSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                ExtractName = row.CellStringValue(1, "ExtractName"),
                FundingStreamPeriodCode = row.CellStringValue(2, "FundingStreamPeriodCode")
            };
        }
    }
}