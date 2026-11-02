namespace Operations.Web.FundDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("FundingAllocation.StatusSubStatusConfig")]
    public partial class StatusSubStatusConfig
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public StatusSubStatusConfig()
        {
            FundingAllocations = new HashSet<FundingAllocation>();
        }

        [Key]
        [Column(Order = 0)]
        [StringLength(50)]
        public string Status { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(50)]
        public string SubStatus { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime CreatedDate { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<FundingAllocation> FundingAllocations { get; set; }
    }
}
