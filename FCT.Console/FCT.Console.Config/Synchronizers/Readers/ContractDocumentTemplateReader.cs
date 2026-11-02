namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class ContractDocumentTemplateReader
    {
        public IReadOnlyCollection<ContractDocumentTemplateSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private ContractDocumentTemplateSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new ContractDocumentTemplateSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                FundingTypeCode = row.CellStringValue(1, "FundingTypeCode"),
                FundingPeriodCode = row.CellStringValue(2, "FundingPeriodCode"),
                DocumentComponentCode = row.CellStringValue(3, "DocumentComponentCode"),
                ContractType = row.CellStringValue(4, "ContractType"),
                Template = row.CellStringValue(5, "Template"),
            };
        }
    }
}
