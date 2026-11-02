namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class SubnominalPaymentTypesReader
    {
        public IReadOnlyCollection<SubnominalsSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private SubnominalsSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new SubnominalsSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                SubnominalCode = row.CellStringValue(9, "SubnominalCode"),
                ShortDescription = row.CellStringValue(10, "ShortDescription"),
                PaymentType = row.CellStringValue(11, "PaymentType")
            };
        }
    }
}