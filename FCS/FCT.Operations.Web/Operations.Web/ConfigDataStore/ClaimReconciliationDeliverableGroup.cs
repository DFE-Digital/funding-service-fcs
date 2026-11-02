namespace Operations.Web.ConfigDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Config.ClaimReconciliationDeliverableGroup")]
    public partial class ClaimReconciliationDeliverableGroup
    {
        [Key]
        [Column(Order = 0)]
        [StringLength(30)]
        public string ClaimReconciliationDeliverableGroupCode { get; set; }

        [StringLength(100)]
        public string ClaimReconciliationDeliverableGroupName { get; set; }

        [Key]
        [Column(Order = 1)]
        public bool CapClaimToProfile { get; set; }

        [Key]
        [Column(Order = 2)]
        public bool ObtainProfileFromReferenceData { get; set; }

        public DateTime? CreatedOn { get; set; }

        public DateTime? ModifiedOn { get; set; }

        public string CreatedBy { get; set; }

        public string ModifiedBy { get; set; }

        public int? ReleaseId { get; set; }

        public bool? ReleaseSync { get; set; }
    }
}
