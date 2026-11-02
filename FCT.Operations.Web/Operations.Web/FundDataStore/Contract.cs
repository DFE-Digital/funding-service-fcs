namespace Operations.Web.FundDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("FundingAllocation.Contract")]
    public partial class Contract
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Contract()
        {
            FundingAllocations = new HashSet<FundingAllocation>();
        }

        public int Id { get; set; }

        [Required]
        [StringLength(50)]
        public string ContractNumber { get; set; }

        public int ContractVersionNumber { get; set; }

        public int ContractSubVersionNumber { get; set; }

        public bool IsCreatedInCrm { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime CreatedDate { get; set; }

        [Required]
        [StringLength(20)]
        public string RelationshipToFundingAllocation { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<FundingAllocation> FundingAllocations { get; set; }
    }
}
