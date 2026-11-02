namespace Operations.Web.FundDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("FundingAllocation.FundingTypeConfig")]
    public partial class FundingTypeConfig
    {
        [Key]
        [StringLength(50)]
        public string FundingTypeCode { get; set; }

        [Required]
        [StringLength(50)]
        public string ContractReferencePrefix { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime CreatedDate { get; set; }
    }
}
