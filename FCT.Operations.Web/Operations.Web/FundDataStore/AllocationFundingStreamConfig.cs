namespace Operations.Web.FundDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("FundingAllocation.AllocationFundingStreamConfig")]
    public partial class AllocationFundingStreamConfig
    {
        [Key]
        [Column(Order = 0)]
        [StringLength(50)]
        public string AllocationFundingStreamCode { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(50)]
        public string AllocationPeriodId { get; set; }

        [Required]
        [StringLength(50)]
        public string FundingTypeCode { get; set; }

        [Required]
        [StringLength(50)]
        public string FundingPeriodCode { get; set; }

        [Required]
        [StringLength(50)]
        public string FSPGroupCode { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime CreatedDate { get; set; }
    }
}
