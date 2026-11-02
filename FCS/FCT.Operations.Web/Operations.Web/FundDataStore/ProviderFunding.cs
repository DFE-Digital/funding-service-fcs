namespace Operations.Web.FundDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("FundingAllocation.ProviderFunding")]
    public partial class ProviderFunding
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public ProviderFunding()
        {
            FundingAllocationLines = new HashSet<FundingAllocationLine>();
            ProviderFundingAllocations = new HashSet<ProviderFundingAllocation>();
        }

        [StringLength(100)]
        public string ProviderFundingId { get; set; }

        public int DeliveryUkprn { get; set; }

        [Required]
        [StringLength(50)]
        public string ProviderType { get; set; }

        [Required]
        [StringLength(50)]
        public string ProviderSubType { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime CreatedDate { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<FundingAllocationLine> FundingAllocationLines { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ProviderFundingAllocation> ProviderFundingAllocations { get; set; }
    }
}
