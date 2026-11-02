namespace Operations.Web.ConfigDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Config.ClaimReconciliationAllocationGroup")]
    public partial class ClaimReconciliationAllocationGroup
    {
        [Key]
        [StringLength(30)]
        public string ClaimReconciliationAllocationGroupCode { get; set; }

        [StringLength(100)]
        public string GroupName { get; set; }

        public DateTime? CreatedOn { get; set; }

        public DateTime? ModifiedOn { get; set; }

        public string CreatedBy { get; set; }

        public string ModifiedBy { get; set; }

        public int? ReleaseId { get; set; }

        public bool? ReleaseSync { get; set; }
    }
}
