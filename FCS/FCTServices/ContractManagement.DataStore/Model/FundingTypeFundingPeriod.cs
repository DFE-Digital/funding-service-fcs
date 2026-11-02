namespace ContractManagement.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class FundingTypeFundingPeriod
    {
     
        [Key]
        [MaxLength(100)]
        [Column(Order = 1)]
        public string FundingTypeCode{ get; set; }

        [Key]
        [MaxLength(100)]
        [Column(Order = 2)]
        public string FundingPeriodName { get; set; }

        [MaxLength(100)]
        public string ApprovalType { get; set; }

        [Required]
        public bool SkipCaseloadAssignment { get; set; }

        [Required]
        public bool SkipReviewAndInternalApproval { get; set; }

        [Required]
        public bool DocumentsRequired { get; set; }

        [Required]
        public bool SkipDocumentMerge { get; set; }

        public DateTime? DefaultContractStartDate { get; set; }

        [MaxLength(100)]
        public string TemplateName { get; set; }

        public DateTime? ContractingActivityCloseDate { get; set; }

        public bool AreContractsOpenEnded { get; set; }

        public bool IsDateAfterContractActivityClose(DateTime date)
        {
            return date.Date > ContractingActivityCloseDate;
        }

        public bool AllowUseOfDeliveryOrgs { get; set; }

        public bool AllowNewAmendment { get; set; }

        public bool IncludeAllContractsOnSummaryOfFunding { get; set; }

        [MaxLength(100)]
        public string AmendmentTemplate { get; set; }
    }
}
