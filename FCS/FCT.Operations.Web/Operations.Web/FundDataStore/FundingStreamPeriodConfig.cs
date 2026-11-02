namespace Operations.Web.FundDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("FundingAllocation.FundingStreamPeriodConfig")]
    public partial class FundingStreamPeriodConfig
    {
        [Key]
        [StringLength(50)]
        public string FundingStreamPeriodCode { get; set; }

        [Required]
        [StringLength(50)]
        public string FundingStreamCode { get; set; }

        [Required]
        [StringLength(50)]
        public string AllocationReferencePrefix { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime CreatedDate { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }
    }
}
