namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class RegionTypeReader
    {
        public IEnumerable<RegionTypeSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
             return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private RegionTypeSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new  RegionTypeSheetType()
            {
                RegionTypeName = row.CellStringValue(1, "RegionTypeName"),
                RegionTypeCode = row.CellIntValue(2, "RegionTypeCode")
            };
        }
    }
}
