namespace Operations.Web.ConfigDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Config.ClaimCollection")]
    public partial class ClaimCollection
    {
        [Key]
        [Column(Order = 0)]
        [StringLength(30)]
        public string ClaimCollectionCode { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(5)]
        public string ClaimTypeCode { get; set; }

        [Key]
        [Column(Order = 2)]
        [StringLength(4)]
        public string Period { get; set; }

        [Key]
        [Column(Order = 3)]
        [StringLength(2)]
        public string PeriodType { get; set; }

        public DateTime? CreatedOn { get; set; }

        public DateTime? ModifiedOn { get; set; }

        public string CreatedBy { get; set; }

        public string ModifiedBy { get; set; }

        public int? ReleaseId { get; set; }

        public bool? ReleaseSync { get; set; }
    }
}
