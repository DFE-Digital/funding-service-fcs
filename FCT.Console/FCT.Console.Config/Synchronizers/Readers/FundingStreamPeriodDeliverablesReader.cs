namespace FCT.Console.Config.Synchronizers.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Excel;
    using ExcelTypes;

    public class FundingStreamPeriodDeliverablesReader
    {
        public IReadOnlyCollection<FundingStreamPeriodDeliverablesSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private FundingStreamPeriodDeliverablesSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new FundingStreamPeriodDeliverablesSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                FundingStreamPeriodCode = row.CellStringValue(1, "FundingStreamPeriodCode"),
                DeliverableCode = int.Parse(row.CellStringValue(2, "DeliverableCode")),
                ParentDeliverableCode = ParseNullableInt(row.CellStringValue(3, "ParentDeliverableCode")),
                DeliverableRelationshipType = row.CellStringValue(4, "DeliverableRelationshipType"),
                DeliverableName = row.CellStringValue(5, "DeliverableName"),
                ParentDeliverableName = row.CellStringValue(6, "ParentDeliverableName"),
                DisplayOrder = int.Parse(row.CellStringValue(7, "DisplayOrder")),
                PlanningUnit = row.CellStringValue(8, "PlanningUnit"),
                Mandatory = row.CellStringValue(9, "Mandatory"),
                AllowProfile = ParseBooleanColumn(row.CellStringValue(10, "AllowProfile")),
                AllowActuals = ParseBooleanColumn(row.CellStringValue(11, "AllowActuals")),
                PaymentSubnominalCodeProfile = row.CellStringValue(12, "PaymentSubnominalCodeProfile"),
                PaymentSubnominalCodeReconciliation = row.CellStringValue(14, "PaymentSubnominalCodeReconciliation"),
                PaymentSubnominalCodeCapping = row.CellStringValue(16, "PaymentSubnominalCodeCapping"),
                AllowPayment = ParseBooleanColumn(row.CellStringValue(18, "AllowPayment")),
                IsPayable = ParseBooleanColumn(row.CellStringValue(18, "IsPayable")),
                DeliverableCappingGroup = row.CellStringValue(19, "DeliverableCappingGroup"),
                AllowCustomDeliverableDesc = ParseBooleanColumn(row.CellStringValue(20, "AllowCustomDeliverableDesc")),
                AllowClaim = ParseBooleanColumn(row.CellStringValue(21, "AllowClaim")),
                ClaimReconciliationDeliverableGroupCode = row.CellStringValueNullIfEmpty(22, "ClaimReconciliationDeliverableGroupCode"),
                CappingApportionmentPriorityOrder =  ParseNullableInt(row.CellStringValue(27, "CappingApportionmentPriorityOrder")),

                DisplayOnFundingAgreement = ParseBooleanColumn(row.CellStringValue(30, "DisplayOnFundingAgreement")),
                MandatoryOnFundingAgreement = ParseBooleanColumn(row.CellStringValue(36, "MandatoryOnFundingAgreement")),
                DisplayOrderOnFundingAgreement = row.CellIntValue(32, "DisplayOrderOnFundingAgreement"),
                AllowCustomDescription = ParseBooleanColumn(row.CellStringValue(33, "AllowCustomDescription")),
                ShouldDisplayValue = ParseBooleanColumn(row.CellStringValue(35, "ShouldDisplayValue")),
                ShouldDisplayVolumeAndUnitCost = ParseBooleanColumn(row.CellStringValue(34, "ShouldDisplayVolumeAndUnitCost")),
                DisplayNameOnSummaryOfFunding = row.CellStringValue(29, "DisplayNameOnSummaryOfFunding"),
                DisplayNameOnFundingAgreement = row.CellStringValue(31, "DisplayNameOnFundingAgreement"),
                DisplayOnSummaryOfFunding = ParseBooleanColumn(row.CellStringValue(28, "DisplayOnSummaryOfFunding"))
            };
        }
        private static int? ParseNullableInt(string stringNumber)
        {
            if (!string.IsNullOrWhiteSpace(stringNumber))
            {
                return int.Parse(stringNumber);
            }
            else
            {
                return null;
            }
        }

        private static bool ParseBooleanColumn(string strBool)
        {
            return strBool.ToUpper() == "YES"  || strBool.ToLower() == "true";
        }
    }
}