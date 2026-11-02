namespace Operations.Web.FundDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("FundingAllocation.BulkUploadStatus")]
    public partial class BulkUploadStatu
    {
        [Key]
        public Guid BulkUploadBatchId { get; set; }

        [Required]
        [StringLength(100)]
        public string FundingTypeCode { get; set; }

        [Required]
        [StringLength(100)]
        public string FundingPeriodName { get; set; }

        [Required]
        [StringLength(100)]
        public string Status { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime CreatedDate { get; set; }
    }
}
