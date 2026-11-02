namespace Operations.Web.FundDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("FundingAllocation.ParkingAndDiscardedInfo")]
    public partial class ParkingAndDiscardedInfo
    {
        [Key]
        [StringLength(200)]
        public string FundingAllocationId { get; set; }

        public DateTime? LastParked { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime CreatedDate { get; set; }

        public DateTime? LastDiscarded { get; set; }

        public virtual FundingAllocation FundingAllocation { get; set; }
    }
}
