namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class ContractTypeReader
    {
        public IReadOnlyCollection<ContractTypeSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private ContractTypeSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new ContractTypeSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                ContractType = row.CellStringValue(1, "ContractType"),
            };
        }
    }
}