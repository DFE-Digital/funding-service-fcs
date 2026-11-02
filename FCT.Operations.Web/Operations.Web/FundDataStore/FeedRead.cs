namespace Operations.Web.FundDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("FundingAllocation.FeedRead")]
    public partial class FeedRead
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public FeedRead()
        {
            FundingAllocationPageControls = new HashSet<FundingAllocationPageControl>();
        }

        [Key]
        public int ReadId { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime? CfsReadCompletedDate { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime CreatedDate { get; set; }

        public DateTime? JobCompletedDate { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<FundingAllocationPageControl> FundingAllocationPageControls { get; set; }
    }
}
