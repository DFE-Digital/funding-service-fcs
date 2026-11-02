namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class CfsCodesToContractTypeReader
    {
        public IReadOnlyCollection<CfsCodesToContractTypeSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private CfsCodesToContractTypeSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new CfsCodesToContractTypeSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                FundingTypeCode = row.CellStringValue(1, "FundingTypeCode"),
                FundingPeriodCode = row.CellStringValue(2, "FundingPeriodCode"),
                ProviderCategory = row.CellStringValue(4, "ProviderCategory"),
                ContractType = row.CellStringValue(5, "ContractType")
            };
        }
    }
}