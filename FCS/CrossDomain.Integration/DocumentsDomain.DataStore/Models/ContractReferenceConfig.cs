namespace SFA.FCT.DocumentsDomain.DataStore.Models
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class ContractReferenceConfig
    {
        public ContractReferenceConfig(int ukprn, string fundingStreamPeriodCode, decimal financialEnvelope1Funding, decimal financialEnvelope2Funding)
        {
            Ukprn = ukprn;
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            FinancialEnvelope1Funding = financialEnvelope1Funding;
            FinancialEnvelope2Funding = financialEnvelope2Funding;
        }

        private ContractReferenceConfig()
        {}

        [Key, Column(Order = 0)]
        public int Ukprn { get; private set; }

        [Key, Column(Order = 1)]
        [MaxLength(50)]
        [Required]
        public string FundingStreamPeriodCode { get; private set; }

        public decimal FinancialEnvelope1Funding { get; private set; }

        public decimal FinancialEnvelope2Funding { get; private set; }
    }
}