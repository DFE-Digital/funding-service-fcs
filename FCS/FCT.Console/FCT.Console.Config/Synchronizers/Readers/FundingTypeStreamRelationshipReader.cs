namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class FundingTypeStreamRelationshipReader
    {
        public IReadOnlyCollection<FundingTypeStreamRelationshipSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private FundingTypeStreamRelationshipSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new FundingTypeStreamRelationshipSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                FundingTypeCode = row.CellStringValue(1, "FundingTypeCode"),
                FundingStreamCode = row.CellStringValue(2, "FundingStreamCode")
            };
        }
    }
}
