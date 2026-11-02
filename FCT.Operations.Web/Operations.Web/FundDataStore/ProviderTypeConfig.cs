namespace Operations.Web.FundDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("FundingAllocation.ProviderTypeConfig")]
    public partial class ProviderTypeConfig
    {
        [Key]
        [Column(Order = 0)]
        [StringLength(50)]
        public string Type { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(50)]
        public string Subtype { get; set; }

        [Required]
        [StringLength(50)]
        public string Category { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime CreatedDate { get; set; }
    }
}
