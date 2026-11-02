namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class ActualsCollectionReturnsReader
    {
        public IReadOnlyCollection<ActualsCollectionReturnsSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private ActualsCollectionReturnsSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new ActualsCollectionReturnsSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                FundingStreamPeriodCode = row.CellStringValue(1, "FundingStreamPeriodCode"),
                MultipleCollectionGroupId = int.Parse(row.CellStringValue(2, "MultipleCollectionGroupId")),
                CollectionType = row.CellStringValue(3, "CollectionType"),
                CollectionReturnCode = row.CellStringValue(4, "CollectionReturnCode")
            };
        }
    }
}