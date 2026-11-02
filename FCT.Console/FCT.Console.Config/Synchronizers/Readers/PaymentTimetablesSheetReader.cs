namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class PaymentTimetablesSheetReader
    {
        public IReadOnlyCollection<PaymentTimetablesSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private PaymentTimetablesSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new PaymentTimetablesSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                FundingStreamPeriodCode = row.CellStringValue(1, "FundingStreamPeriodCode"),
                CalendarPeriod = row.CellStringValue(2, "CalendarPeriod"),
                CalendarPeriodType = row.CellStringValue(3, "CalendarPeriodType"),
                FinancialPeriod = row.CellStringValue(4, "FinancialPeriod"),
                FinancialPeriodType = row.CellStringValue(5, "FinancialPeriodType"),
                PeriodStartDate = row.CellDateValue(6, "PeriodStartDate"),
                PeriodEndDate = row.CellDateValue(7, "PeriodEndDate"),
                CensusEndDate = row.CellDateValue(8, "CensusEndDate"),
                DueDate = row.CellNullableDateValue(9, "DueDate"),
                LinkCodeSuffix = row.CellStringValue(12, "LinkCodeSuffix"),
                PayCalcPolicyVersion = row.NullableIntValue(13, "PayCalcPolicyVersion"),
                Status = "NotStarted"
            };
        }
    }
}
