namespace Operations.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class FundingReportProvider
    {
        private FundingReportProvider()
        {}

        public FundingReportProvider(int ukprn, string fundingPeriod, string type, int period)
        {
            Ukprn = ukprn;
            FundingPeriod = fundingPeriod;
            Type = type;
            Period = period;
        }

        [Key, Column(Order = 0)]
        public int Ukprn { get; private set; }

        [Key, Column(Order = 1), MaxLength(50), Required]
        public string FundingPeriod { get; private set; }

        [MaxLength(30), Required]
        public string Type { get; set; }

        [Required]
        public int Period { get; set; }
    }
}
