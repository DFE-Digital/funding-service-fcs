namespace Operations.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class FundingReportFSP
    {
        private FundingReportFSP()
        {
        }

        public FundingReportFSP(string fspCode, int order, string fundingPeriod, string description)
        {
            FspCode = fspCode;
            Order = order;
            FundingPeriod = fundingPeriod;
            Description = description;
        }

        [Key, Column(Order = 0), MaxLength(100)]
        public string FspCode { get; private set; }

        [Required]
        public int Order { get; set; }

        [Key, Column(Order = 1), MaxLength(100)]
        public string FundingPeriod { get; private set; }

        [Required, MaxLength(150)]
        public string Description { get; set; }

        public override string ToString() => $"FspCode: {FspCode}";
    }
}
