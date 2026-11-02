namespace Operations.Web.FundDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("FundingAllocation.FspDeliverableConfig")]
    public partial class FspDeliverableConfig
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public FspDeliverableConfig()
        {
            AllocationLineConfigs = new HashSet<AllocationLineConfig>();
        }

        [Key]
        [Column(Order = 0)]
        [StringLength(50)]
        public string FspCode { get; set; }

        [Key]
        [Column(Order = 1)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int DeliverableCode { get; set; }

        [Required]
        [StringLength(100)]
        public string DeliverableName { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime CreatedDate { get; set; }

        public int DisplayOrder { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<AllocationLineConfig> AllocationLineConfigs { get; set; }
    }
}
