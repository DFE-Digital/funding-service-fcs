namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class ESFRegionInvestmentPriorityReader
    {
        public IEnumerable<ESFRegionInvestmentPrioritySheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private ESFRegionInvestmentPrioritySheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new ESFRegionInvestmentPrioritySheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                RegionType = row.CellStringValue(1, "RegionType").Trim().Replace(" ", string.Empty),
                InvestmentPriorityString = row.CellStringValue(2, "InvestmentPriorityString"),
                SubnominalCode = row.CellStringValue(6, "SubnominalCode")
            };
        }
    }
}