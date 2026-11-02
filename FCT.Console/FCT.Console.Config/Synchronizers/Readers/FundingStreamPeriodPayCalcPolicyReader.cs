namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class FundingStreamPeriodPayCalcPolicyReader
    {
        public IEnumerable<FundingStreamPeriodPayCalcPolicySheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private static FundingStreamPeriodPayCalcPolicySheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new FundingStreamPeriodPayCalcPolicySheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                FundingStreamPeriodCode = row.CellStringValue(1, "FundingStreamPeriodCode"),
                CalcPolicyVersion = row.CellIntValue(2, "CalcPolicyVersion"),
                PaymentCappingPeriod = row.CellStringValue(3, "PaymentCappingPeriod")
            };
        }
    }
}
