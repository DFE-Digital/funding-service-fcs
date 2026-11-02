namespace FCT.Console.Config.Synchronizers.Readers
{
    using Excel;
    using ExcelTypes;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class ClaimReconciliationBehaviourReader
    {
        public IReadOnlyCollection<ClaimReconciliationBehaviourSheetType> ReadConfig(IWorksheetReader worksheetReader)
        {
            return worksheetReader.DataRows().Select(ReadAndTransformRow).Where(r => r.PolicyStatus != PolicyStatus.Draft).ToList();
        }

        private ClaimReconciliationBehaviourSheetType ReadAndTransformRow(WorksheetRowReader row)
        {
            return new ClaimReconciliationBehaviourSheetType
            {
                PolicyStatus = SheetTypeBase.ParsePolicyStatus(row.CellStringValue(0, "PolicyStatus")),
                ClaimCollectionCode = row.CellStringValue(1, "ClaimCollectionCode"),
                ClaimReconciliationAllocationGroupCode = row.CellStringValue(2, "ClaimReconciliationAllocationGroupCode"),
                IsReconciliationPayable = row.CellBooleanValue(3, "IsReconciliationPayable"),
                DoWeReconcileOverDelivery = row.CellBooleanValue(4, "DoWeReconcileOverDelivery"),
                DoWeReconcileUnderDelivery = row.CellBooleanValue(5, "DoWeReconcileUnderDelivery"),
                OverDeliveryDeMinimis = row.CellCurrencyValue(6, "OverDeliveryDeMinimis"),
                UnderDeliveryDeMinimis = row.CellCurrencyValue(7, "UnderDeliveryDeMinimis"),
                PublicationCloseDate = row.CellNullableDateValue(8, "PublicationCloseDate"),
                UnderDeliveryTolerancePercentage = row.CellCurrencyValue(9, "UnderDeliveryTolerancePercentage"),
                OverDeliveryLimitPercentage = row.CellNullableCurrencyValue(10, "OverDeliveryLimitPercentage"),
                ClaimTypeCode = row.CellStringValue(12, "ClaimTypeCode"),
                FundingPeriod = row.CellStringValue(13, "FundingPeriod"),
                UnderDeliveryRecoveryAmount = ParseUnderDeliveryRecoveryAmount(row.CellStringValue(14, "UnderDeliveryRecoveryAmount"))
            };
        }

        public static UnderDeliveryRecoveryAmount ParseUnderDeliveryRecoveryAmount(string underDeliveryRecoveryAmountString)
        {
            if (IsJsonIntValue(underDeliveryRecoveryAmountString))
            {
                var jsonIntValue = int.Parse(underDeliveryRecoveryAmountString);
                return (UnderDeliveryRecoveryAmount)Enum.ToObject(typeof(UnderDeliveryRecoveryAmount), jsonIntValue);
            }

            return (UnderDeliveryRecoveryAmount)Enum.Parse(typeof(UnderDeliveryRecoveryAmount), underDeliveryRecoveryAmountString.Replace(" ", string.Empty), ignoreCase: true);
        }

        private static bool IsJsonIntValue(string stringValue)
        {
            return int.TryParse(stringValue, out _);
        }
    }
}
