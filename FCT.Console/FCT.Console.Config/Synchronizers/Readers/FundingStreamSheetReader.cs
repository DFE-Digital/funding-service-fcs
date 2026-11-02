namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class FundingStreamSheetReader
    {
        private string _agencyCode;

        public IReadOnlyCollection<FundingStreamSheetType> ReadConfig(IWorksheetReader worksheetReader, string agencyCode)
        {
            _agencyCode = agencyCode;
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private FundingStreamSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new FundingStreamSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                Code = row.CellStringValue(1, "Code"),
                Name = row.CellStringValue(2, "Name"),
                FinanceShortCode = row.CellStringValue(3, "FinanceShortCode"), 
                StartDate = row.CellNullableDateValue(4, "StartDate"),
                EndDate = row.CellNullableDateValue(5, "EndDate"),
                AgencyCode = _agencyCode
            };
        }
    }
}