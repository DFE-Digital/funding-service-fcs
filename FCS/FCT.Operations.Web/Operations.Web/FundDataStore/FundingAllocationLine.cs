namespace Operations.Web.FundDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("FundingAllocation.FundingAllocationLine")]
    public partial class FundingAllocationLine
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public FundingAllocationLine()
        {
            FundingAllocationProfilePeriods = new HashSet<FundingAllocationProfilePeriod>();
        }

        [Key]
        [Column(Order = 0)]
        [StringLength(100)]
        public string ProviderFundingId { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(50)]
        public string FundingLineCode { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime CreatedDate { get; set; }

        public bool IsOfNoInterest { get; set; }

        public virtual ProviderFunding ProviderFunding { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<FundingAllocationProfilePeriod> FundingAllocationProfilePeriods { get; set; }
    }
}
