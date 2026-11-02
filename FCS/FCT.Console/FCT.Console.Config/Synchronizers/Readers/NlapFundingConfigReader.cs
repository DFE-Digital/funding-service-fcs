namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class NlapFundingConfigReader
    {
        public IEnumerable<NlapFundingConfigSheet> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private static NlapFundingConfigSheet ReadAndTransformRow(WorksheetRowReader row)
        {
            return new NlapFundingConfigSheet
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                Ukprn = row.CellIntValue(1, "Ukprn"),
                NewStarts2021Funding1618 = row.CellCurrencyValue(2, "NewStarts2021Funding1618"),
                NewStarts2021FundingAdult = row.CellCurrencyValue(3, "NewStarts2021FundingAdult"),
                NewStartsEstimatedFutureFunding1618 = row.CellCurrencyValue(4, "NewStartsEstimatedFutureFunding1618"),
                NewStartsEstimatedFutureFundingAdult = row.CellCurrencyValue(5, "NewStartsEstimatedFutureFundingAdult")
            };
        }
    }
}
