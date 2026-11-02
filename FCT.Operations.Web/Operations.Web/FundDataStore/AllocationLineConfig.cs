namespace Operations.Web.FundDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("FundingAllocation.AllocationLineConfig")]
    public partial class AllocationLineConfig
    {
        [Key]
        [Column(Order = 0)]
        [StringLength(50)]
        public string FundingStreamCode { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(50)]
        public string PeriodId { get; set; }

        [Key]
        [Column(Order = 2)]
        [StringLength(50)]
        public string FundingLineCode { get; set; }

        [Key]
        [Column(Order = 3)]
        [StringLength(50)]
        public string ProviderCategory { get; set; }

        [Required]
        [StringLength(50)]
        public string FspCode { get; set; }

        public int DeliverableCode { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime CreatedDate { get; set; }

        public virtual FspDeliverableConfig FspDeliverableConfig { get; set; }
    }
}
