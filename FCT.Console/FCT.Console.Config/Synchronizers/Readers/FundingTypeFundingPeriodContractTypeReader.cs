namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class FundingTypeFundingPeriodContractTypeReader
    {
        public IReadOnlyCollection<FTPCoTSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private FTPCoTSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new FTPCoTSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                FundingTypeCode = row.CellStringValue(1, "FundingTypeCode"),
                FundingPeriodCode = row.CellStringValue(2, "FundingPeriodCode"),
                ContractType = row.CellStringValue(3, "ContractType"),
                DefinedContractTermForProvider  = row.CellStringValue(4, "DefinedContractTermForProvider")
            };
        }
    }
}