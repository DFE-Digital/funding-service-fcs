namespace Operations.Web.FundDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("FundingAllocation.ProviderFundingAllocation")]
    public partial class ProviderFundingAllocation
    {
        [Key]
        [Column(Order = 0)]
        [StringLength(100)]
        public string ProviderFundingId { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(200)]
        public string FundingId { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime CreatedDate { get; set; }

        public virtual FundingAllocation FundingAllocation { get; set; }

        public virtual ProviderFunding ProviderFunding { get; set; }
    }
}
