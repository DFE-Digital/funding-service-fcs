namespace Operations.Web.FundDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("FundingAllocation.FundingAllocationProfilePeriod")]
    public partial class FundingAllocationProfilePeriod
    {
        [Key]
        [Column(Order = 0)]
        [StringLength(100)]
        public string ProviderFundingId { get; set; }

        [Key]
        [Column(Order = 1)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int Period { get; set; }

        public decimal PlannedValue { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime CreatedDate { get; set; }

        [Key]
        [Column(Order = 2)]
        [StringLength(50)]
        public string FundingLineCode { get; set; }

        public virtual FundingAllocationLine FundingAllocationLine { get; set; }
    }
}
