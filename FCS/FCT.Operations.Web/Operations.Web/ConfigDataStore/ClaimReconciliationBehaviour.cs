namespace Operations.Web.ConfigDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Config.ClaimReconciliationBehaviour")]
    public partial class ClaimReconciliationBehaviour
    {
        [Key]
        [Column(Order = 0)]
        [StringLength(30)]
        public string ClaimCollectionCode { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(30)]
        public string ClaimReconciliationAllocationGroupCode { get; set; }

        [Key]
        [Column(Order = 2)]
        public bool IsReconciliationPayable { get; set; }

        [Key]
        [Column(Order = 3)]
        public decimal OverDeliveryDeMinimis { get; set; }

        [Key]
        [Column(Order = 4)]
        public decimal UnderDeliveryDeMinimis { get; set; }

        [Key]
        [Column(Order = 5)]
        public bool DoWeReconcileUnderDelivery { get; set; }

        [Key]
        [Column(Order = 6)]
        public bool DoWeReconcileOverDelivery { get; set; }

        public DateTime? PublicationCloseDate { get; set; }

        [Key]
        [Column(Order = 7)]
        public decimal UnderDeliveryTolerancePercentage { get; set; }

        public decimal? OverDeliveryLimitPercentage { get; set; }

        [Key]
        [Column(Order = 8)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int UnderDeliveryRecoveryAmount { get; set; }

        public DateTime? CreatedOn { get; set; }

        public DateTime? ModifiedOn { get; set; }

        public string CreatedBy { get; set; }

        public string ModifiedBy { get; set; }

        public int? ReleaseId { get; set; }

        public bool? ReleaseSync { get; set; }
    }
}
