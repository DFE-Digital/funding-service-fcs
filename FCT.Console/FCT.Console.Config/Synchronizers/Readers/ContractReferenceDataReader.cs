namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class ContractReferenceDataReader
    {
        public IEnumerable<ContractReferenceDataSheet> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private static ContractReferenceDataSheet ReadAndTransformRow(WorksheetRowReader row)
        {
            return new ContractReferenceDataSheet
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                Ukprn = row.CellIntValue(1, "Ukprn"),
                FundingStreamPeriodCode = row.CellStringValue(2, "FundingStreamPeriodCode"),
                FinancialEnvelope1Funding = row.CellCurrencyValue(3, "FinancialEnvelope1Funding"),
                FinancialEnvelope2Funding = row.CellCurrencyValue(4, "FinancialEnvelope2Funding"),
            };
        }
    }
}