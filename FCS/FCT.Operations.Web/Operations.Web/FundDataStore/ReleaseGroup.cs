namespace Operations.Web.FundDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("FundingAllocation.ReleaseGroup")]
    public partial class ReleaseGroup
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public ReleaseGroup()
        {
            FundingAllocations = new HashSet<FundingAllocation>();
        }

        public int Id { get; set; }

        [Required]
        [StringLength(50)]
        public string FundingTypeCode { get; set; }

        [Required]
        [StringLength(50)]
        public string FundingPeriodCode { get; set; }

        [Required]
        [StringLength(50)]
        public string FSPGroupCode { get; set; }

        [Required]
        [StringLength(100)]
        public string ContractType { get; set; }

        public Guid CrmEntityId { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime CreatedDate { get; set; }

        [Required]
        [StringLength(50)]
        public string ReleaseGroupName { get; set; }

        [Required]
        [StringLength(50)]
        public string Status { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime? ReleasedDate { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<FundingAllocation> FundingAllocations { get; set; }
    }
}
