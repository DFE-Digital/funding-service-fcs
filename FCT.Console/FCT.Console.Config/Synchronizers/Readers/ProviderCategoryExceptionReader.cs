namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class ProviderCategoryExceptionReader
    {
        public IReadOnlyCollection<ProviderCategoryException> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private ProviderCategoryException ReadAndTransformRow(WorksheetRowReader row)
        {
            return new ProviderCategoryException
            {
                FundingTypeCode = row.CellStringValue(1, "FundingTypeCode"),
                FundingPeriodCode = row.CellStringValue(2, "FundingPeriodCode"),
                UKPRN = row.CellStringValue(3, "UKPRN"),
                Category = row.CellStringValue(4, "Category"),
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus"))
            };
        }
    }
}
