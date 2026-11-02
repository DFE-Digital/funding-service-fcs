namespace Operations.Web.ConfigDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Config.ClaimReconciliationAllocationGroupFsp")]
    public partial class ClaimReconciliationAllocationGroupFsp
    {
        [StringLength(30)]
        public string ClaimReconciliationAllocationGroupCode { get; set; }

        [Key]
        [StringLength(30)]
        public string FspCode { get; set; }

        public DateTime? CreatedOn { get; set; }

        public DateTime? ModifiedOn { get; set; }

        public string CreatedBy { get; set; }

        public string ModifiedBy { get; set; }

        public int? ReleaseId { get; set; }

        public bool? ReleaseSync { get; set; }
    }
}
