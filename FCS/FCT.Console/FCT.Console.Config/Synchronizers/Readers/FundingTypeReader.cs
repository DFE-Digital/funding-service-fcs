using System;

namespace FCT.Console.Config.Synchronizers.Readers
{
    using Excel;
    using ExcelTypes;
    using System.Collections.Generic;
    using System.Linq;

    public class FundingTypeReader
    {
        public IReadOnlyCollection<FundingTypeSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private FundingTypeSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new FundingTypeSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                FundingTypeName = row.CellStringValue(1, "FundingTypeName"),
                FundingTypeCode = row.CellStringValue(2, "FundingTypeCode"),
                AgencyCode = int.Parse(row.CellStringValue(3, "AgencyCode")),
                ContractReferencePrefix = row.CellStringValue(4, "ContractReferencePrefix"),
                AllowMultipleContracts = row.CellBooleanValue(5, "AllowMultipleContracts"),
                DocumentationRequired = row.CellBooleanValue(6, "DocumentationRequired")
            };
        }
    }
}
