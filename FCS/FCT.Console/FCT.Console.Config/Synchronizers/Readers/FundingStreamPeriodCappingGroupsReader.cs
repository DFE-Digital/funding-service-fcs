namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class FundingStreamPeriodCappingGroupsReader
    {
        public IEnumerable<FundingStreamPeriodCappingGroupSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private FundingStreamPeriodCappingGroupSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new FundingStreamPeriodCappingGroupSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                FundingStreamPeriod = row.CellStringValue(1, "FundingStreamPeriod"),
                CappingGroupName = row.CellStringValue(2, "CappingGroupName"),
                AllowUnderDeliveryToBeReUsed = row.CellBooleanValue(3, "AllowUnderDeliveryToBeReUsed"),
                AllowOverDeliveryToBeOffset = row.CellBooleanValue(4, "AllowOverDeliveryToBeOffset"),
                FundingStreamPeriodCappingGroupId = int.Parse(row.CellStringValue(5, "FundingStreamPeriodCappingGroupId"))
            };
        }
    }
}
