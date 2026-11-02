namespace Operations.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;

    public class FundingStreamPeriod
    {
        private FundingStreamPeriod()
        {}

        public FundingStreamPeriod(string fundingStreamPeriodCode, string periodTypeCode)
        {
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            PeriodTypeCode = periodTypeCode;
        }

        [Key, MaxLength(100)]
        public string FundingStreamPeriodCode { get; private set; }
        
        [Required, MaxLength(50)]
        public string PeriodTypeCode { get; set; }
    }
}
