namespace FCT.Console.Config.ExcelTypes
{
    using System;

    public class FundingTypePeriodSheetType : SheetTypeBase
    {
        public string FundingTypeName { get; set; }
        public string FundingTypeCode { get; set; }
        public string FundingPeriod { get; set; }
        public string ApprovalType { get; set; }
        public string FundingTypeFundingPeriodName => $"{FundingTypeName} - {FundingPeriod}";
        public string FundingPeriodName => FundingPeriod;
        public bool SkipCaseloadAssignment { get; set; }
        public bool SkipReviewAndInternalApproval { get; set; }
        public bool DocumentsRequired { get; set; }
        public bool SkipDocumentMerge { get; set; }
        public DateTime? DefaultContractStartDate { get; set; }
        public string TemplateName { get; set; }
        public DateTime? ContractingActivityCloseDate { get; set; }
        public bool AreContractsOpenEnded { get; set; }
        public bool AllowUseOfDeliveryOrgs { get; set; }
        public bool AllowNewAmendment { get; set; }
        public bool IncludeAllContractsOnSummaryOfFunding { get; set; }
        public string AmendmentTemplate { get; set; }
        public bool OnlyGenerateFundingAgreementForNewOrUpdatedAllocations { get; set; }
        public string FtpGroupCode { get; set; }
        public string PrecedingFtpFundingType { get; set; }
        public string PrecedingFtpFundingPeriod { get; set; }
        public bool? AllAmendmentsRequireSigning { get; set; }
        public DateTime? ContractExpiryDate { get; set; }
    }
}
