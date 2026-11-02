namespace SFA.FCT.DocumentsDomain.DataStore.Models
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class FundingTypeFundingPeriod
    {
        private FundingTypeFundingPeriod()
        {
        }

        public FundingTypeFundingPeriod(string fundingTypeCode, string fundingPeriodName, bool onlyGenerateFundingAgreementForNewOrUpdatedAllocations)
        {
            FundingTypeCode = fundingTypeCode;
            FundingPeriodName = fundingPeriodName;
            OnlyGenerateFundingAgreementForNewOrUpdatedAllocations = onlyGenerateFundingAgreementForNewOrUpdatedAllocations;
        }

        [Key]
        [MaxLength(100)]
        [Column(Order = 1)]
        public string FundingTypeCode { get; private set; }

        [Key]
        [MaxLength(100)]
        [Column(Order = 2)]
        public string FundingPeriodName { get; private set; }

        [Required]
        public bool OnlyGenerateFundingAgreementForNewOrUpdatedAllocations { get; set; }

        [Required]
        public bool DocumentsRequired { get; set; }
    }
}