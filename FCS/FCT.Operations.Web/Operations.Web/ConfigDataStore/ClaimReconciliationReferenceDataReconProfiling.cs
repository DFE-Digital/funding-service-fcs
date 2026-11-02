namespace Operations.Web.ConfigDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Config.ClaimReconciliationReferenceDataReconProfiling")]
    public partial class ClaimReconciliationReferenceDataReconProfiling
    {
        [Key]
        [Column(Order = 0)]
        [StringLength(30)]
        public string FundingPeriod { get; set; }

        [Key]
        [Column(Order = 1)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int Ukprn { get; set; }

        [Key]
        [Column(Order = 2)]
        public DateTime CreatedDate { get; set; }

        public DateTime? CreatedOn { get; set; }

        public DateTime? ModifiedOn { get; set; }

        public string CreatedBy { get; set; }

        public string ModifiedBy { get; set; }

        public int? ReleaseId { get; set; }

        public bool? ReleaseSync { get; set; }
    }
}
