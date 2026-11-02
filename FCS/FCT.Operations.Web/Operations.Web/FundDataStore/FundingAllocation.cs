namespace Operations.Web.FundDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("FundingAllocation.FundingAllocation")]
    public partial class FundingAllocation
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public FundingAllocation()
        {
            ProviderFundingAllocations = new HashSet<ProviderFundingAllocation>();
        }

        [Key]
        [StringLength(200)]
        public string FundingId { get; set; }

        [Required]
        [StringLength(50)]
        public string FundingVersion { get; set; }

        [Required]
        [StringLength(50)]
        public string Period { get; set; }

        [Required]
        [StringLength(50)]
        public string AllocationFundingStream { get; set; }

        [Required]
        [StringLength(50)]
        public string UKPRN { get; set; }

        public decimal Value { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime CreatedDate { get; set; }

        public int PositionInPage { get; set; }

        public int PageNumber { get; set; }

        public int ProviderFundingCount { get; set; }

        public int? ContractId { get; set; }

        public Guid? CrmEntityId { get; set; }

        public int? ReleaseGroupId { get; set; }

        public int ReadId { get; set; }

        [StringLength(50)]
        public string Status { get; set; }

        [Required]
        [StringLength(200)]
        public string FundingAllocationName { get; set; }

        [StringLength(50)]
        public string SubStatus { get; set; }

        public bool IsPublished { get; set; }

        public virtual Contract Contract { get; set; }

        public virtual FundingAllocationPageControl FundingAllocationPageControl { get; set; }

        public virtual ReleaseGroup ReleaseGroup { get; set; }

        public virtual StatusSubStatusConfig StatusSubStatusConfig { get; set; }

        public virtual ParkingAndDiscardedInfo ParkingAndDiscardedInfo { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ProviderFundingAllocation> ProviderFundingAllocations { get; set; }
    }
}
