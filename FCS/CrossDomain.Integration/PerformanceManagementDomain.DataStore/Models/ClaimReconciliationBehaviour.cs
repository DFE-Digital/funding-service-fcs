namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class ClaimReconciliationBehaviour
    {
        private ClaimReconciliationBehaviour()
        {
        }

        public ClaimReconciliationBehaviour(
            string claimCollectionCode,
            string claimReconciliationAllocationGroupCode,
            bool isReconciliationPayable,
            bool doWeReconcileUnderDelivery,
            bool doWeReconcileOverDelivery,
            decimal overDeliveryDeMinimis,
            decimal underDeliveryDeMinimis,
            DateTime? publicationCloseDate,
            decimal underDeliveryTolerancePercentage,
            decimal? overDeliveryLimitPercentage,
            UnderDeliveryRecoveryAmount underDeliveryRecoveryAmount)
        {
            ClaimCollectionCode = claimCollectionCode;
            ClaimReconciliationAllocationGroupCode = claimReconciliationAllocationGroupCode;
            IsReconciliationPayable = isReconciliationPayable;
            DoWeReconcileUnderDelivery = doWeReconcileUnderDelivery;
            DoWeReconcileOverDelivery = doWeReconcileOverDelivery;
            OverDeliveryDeMinimis = overDeliveryDeMinimis;
            UnderDeliveryDeMinimis = underDeliveryDeMinimis;
            PublicationCloseDate = publicationCloseDate;
            UnderDeliveryTolerancePercentage = underDeliveryTolerancePercentage;
            OverDeliveryLimitPercentage = overDeliveryLimitPercentage;
            UnderDeliveryRecoveryAmount = underDeliveryRecoveryAmount;
        }

        [Key, Column(Order = 0)]
        [MaxLength(30)]
        public string ClaimCollectionCode { get; private set; }

        [Key, Column(Order = 1)]
        [MaxLength(30)]
        public string ClaimReconciliationAllocationGroupCode { get; private set; }

        [Required]
        public bool IsReconciliationPayable { get; set; }

        [Required]
        public bool DoWeReconcileUnderDelivery { get; set; }

        [Required]
        public bool DoWeReconcileOverDelivery { get; set; }

        [Required]
        public decimal OverDeliveryDeMinimis { get; set; }

        [Required]
        public decimal UnderDeliveryDeMinimis { get; set; }

        public DateTime? PublicationCloseDate { get; set; }

        [Required]
        public decimal UnderDeliveryTolerancePercentage { get; set; }

        public decimal? OverDeliveryLimitPercentage { get; set; }

        [Required]
        public UnderDeliveryRecoveryAmount UnderDeliveryRecoveryAmount { get; set; }

        public ClaimCollection ClaimCollection { get; set; }

        public ClaimReconciliationAllocationGroup ClaimReconciliationAllocationGroup { get; set; }
    }

    public enum UnderDeliveryRecoveryAmount
    {
        Full,
        Excess,
        ExcessUnlessNoDelivery
    }
}
