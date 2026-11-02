namespace Operations.Web.FundDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("FundingAllocation.FundingTypeFundingPeriodConfig")]
    public partial class FundingTypeFundingPeriodConfig
    {
        [Key]
        [Column(Order = 0)]
        [StringLength(50)]
        public string FundingTypeCode { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(50)]
        public string FundingPeriod { get; set; }

        [StringLength(50)]
        public string FtpGroupCode { get; set; }

        [StringLength(50)]
        public string PrecedingFtpFundingType { get; set; }

        [StringLength(50)]
        public string PrecedingFtpFundingPeriod { get; set; }

        public bool IncludeAllContractsOnSummaryOfFunding { get; set; }

        public bool AllowNewAmendment { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime CreatedDate { get; set; }

        public bool? AllAmendmentsRequireSigning { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime? ContractExpiryDate { get; set; }
    }
}
