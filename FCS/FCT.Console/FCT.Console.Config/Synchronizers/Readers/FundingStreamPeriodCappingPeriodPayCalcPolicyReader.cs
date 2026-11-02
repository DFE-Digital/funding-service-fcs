namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class FundingStreamPeriodCappingPeriodPayCalcPolicyReader
    {
        public IEnumerable<FundingStreamPeriodCappingPeriodPayCalcPolicySheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private static FundingStreamPeriodCappingPeriodPayCalcPolicySheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new FundingStreamPeriodCappingPeriodPayCalcPolicySheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                FundingStreamPeriodCode = row.CellStringValue(1, "FundingStreamPeriodCode"),
                CalcPolicyVersion = row.CellIntValue(2, "CalcPolicyVersion"),
                CappingPeriod = row.CellIntValue(3, "CappingPeriod"),
                OverDeliveryLimit = row.CellDecimalValue(4, "OverDeliveryLimit")
            };
        }
    }
}