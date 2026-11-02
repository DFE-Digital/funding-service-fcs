namespace SFA.FCT.DocumentsDomain.DataStore.Models
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class FundingStreamPeriod
    {
        public FundingStreamPeriod(string fundingStreamPeriodCode, string summaryOfFundingDisplayName, 
            int displayOrder, bool shouldGenerateFundingAgreement, 
            bool shouldUseContractAllocationDescription, string template, 
            string extraPagesTemplate,
            string fspGroupCode,
            string fundingAgreementDisplayName)
        {
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            SummaryOfFundingDisplayName = summaryOfFundingDisplayName;
            DisplayOrder = displayOrder;
            ShouldGenerateFundingAgreement = shouldGenerateFundingAgreement;
            ShouldUseContractAllocationDescription = shouldUseContractAllocationDescription;
            Template = template;
            ExtraPagesTemplate = extraPagesTemplate;
            FSPGroupCode = fspGroupCode;
            FundingAgreementDisplayName = fundingAgreementDisplayName;
        }

        // for Entity Framework to call
        private FundingStreamPeriod()
        {
        }

        [Key]
        [MaxLength(100)]
        public string FundingStreamPeriodCode { get; private set; }

        [MaxLength(100)]
        public string SummaryOfFundingDisplayName { get; set; }

        [Required]
        public int DisplayOrder { get; set; }

        public bool ShouldGenerateFundingAgreement { get; set; }

        public bool ShouldUseContractAllocationDescription { get; set; }

        [MaxLength(50)]
        public string Template { get; set; }

        [MaxLength(50)]
        public string ExtraPagesTemplate { get; set; }

        public virtual ICollection<FSPDeliverable> FspDeliverables { get; set; }

        [MaxLength(50)]
        public string FSPGroupCode { get; private set; }

        [MaxLength(200)]
        public string FundingAgreementDisplayName { get; private set; }

        [ForeignKey("FSPGroupCode")]
        public virtual FSPGroup FspGroup { get; set; }
    }
}