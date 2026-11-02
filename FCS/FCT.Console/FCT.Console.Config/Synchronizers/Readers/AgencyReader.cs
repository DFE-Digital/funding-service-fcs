namespace FCT.Console.Config.Synchronizers.Readers
{
    using Excel;
    using ExcelTypes;
    using System.Collections.Generic;
    using System.Linq;

    public class AgencyReader
    {
        public IReadOnlyCollection<AgencySheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRowNew).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private AgencySheetType ReadAndTransformRowNew(WorksheetRowReader row)
        {
            return new AgencySheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                AgencyCode = row.CellStringValue(1, "AgencyCode"),
                AgencyShortCode = row.CellStringValue(2, "AgencyShortCode"),
                Description = row.CellStringValue(3, "Description"),
                ContractReferencePrefix = row.CellStringValue(4, "ContractReferencePrefix"),
            };
        }
    }
}
