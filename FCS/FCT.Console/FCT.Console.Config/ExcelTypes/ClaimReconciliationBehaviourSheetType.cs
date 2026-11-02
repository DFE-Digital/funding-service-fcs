namespace FCT.Console.Config.ExcelTypes
{
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using System;

    public class ClaimReconciliationBehaviourSheetType : SheetTypeBase
    {
        public string ClaimCollectionCode { get; set; }

        public string ClaimReconciliationAllocationGroupCode { get; set; }

        public bool IsReconciliationPayable { get; set; }

        public bool DoWeReconcileUnderDelivery { get; set; }

        public bool DoWeReconcileOverDelivery { get; set; }

        public decimal OverDeliveryDeMinimis { get; set; }

        public decimal UnderDeliveryDeMinimis { get; set; }

        public DateTime? PublicationCloseDate { get; set; }

        public decimal UnderDeliveryTolerancePercentage { get; set; }

        public decimal? OverDeliveryLimitPercentage { get; set; }

        public string ClaimTypeCode { get; set; }

        public string FundingPeriod { get; set; }

        public UnderDeliveryRecoveryAmount UnderDeliveryRecoveryAmount { get; set; }
    }
}
