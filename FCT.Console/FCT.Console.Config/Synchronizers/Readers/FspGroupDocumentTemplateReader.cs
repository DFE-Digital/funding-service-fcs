namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class FspGroupDocumentTemplateReader
    {
        public IReadOnlyCollection<FspGroupDocumentTemplateSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private FspGroupDocumentTemplateSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new FspGroupDocumentTemplateSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                FundingTypeCode = row.CellStringValue(1, "FundingTypeCode"),
                FundingPeriodCode = row.CellStringValue(2, "FundingPeriodCode"),
                DocumentComponentCode = row.CellStringValue(3, "DocumentComponentCode"),
                FspGroupCode = row.CellStringValue(4, "FspGroupCode"),
                ContractType = row.CellStringValue(5, "ContractType"),
                Template = row.CellStringValue(6, "Template"),
                ContractTypeNonDefault = row.CellStringValue(7, "ContractTypeNonDefault"),
            };
        }
    }
}