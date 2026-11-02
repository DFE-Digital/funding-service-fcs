namespace ContractManagement.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class FundingTypePeriodFundingStreamPeriod
    {
        public FundingTypePeriodFundingStreamPeriod(string fundingTypeCode, string fundingPeriodCode, string fundingStreamCode)
        {
            FundingTypeCode = fundingTypeCode;
            FundingPeriodCode = fundingPeriodCode;
            FundingStreamCode = fundingStreamCode;
        }

        private FundingTypePeriodFundingStreamPeriod()
        {
        }

        [Key]
        [MaxLength(100)]
        [Column(Order = 1)]
        public string FundingTypeCode { get; private set; }

        [Key]
        [MaxLength(100)]
        [Column(Order = 2)]
        public string FundingPeriodCode { get; private set; }

        [Key]
        [MaxLength(100)]
        [Column(Order = 3)]
        public string FundingStreamCode { get; private set; }
    }
}