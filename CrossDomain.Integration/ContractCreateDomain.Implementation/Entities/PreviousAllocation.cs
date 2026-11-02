namespace SFA.FCT.ContractCreateDomain.Implementation.Entities
{
    using System;

    public class PreviousAllocation
    {
        public PreviousAllocation(string allocationNumber, DateTime? startDate, DateTime? endDate, string fundingStreamCode, string fundingStreamPeriodCode, string lepName, string lepCode, string tenderSpecReference, string lotReference, string tenderAwardReference, string activityDescription, string allocationDescription, string amendmentReason, string investmentPriority, string agreementNumber, string specificationTitle, string regionType, string learningRatePremium)
        {
            AllocationNumber = allocationNumber;
            StartDate = startDate;
            EndDate = endDate;
            FundingStreamCode = fundingStreamCode;
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            LepName = lepName;
            LepCode = lepCode;
            TenderSpecReference = tenderSpecReference;
            LotReference = lotReference;
            TenderAwardReference = tenderAwardReference;
            ActivityDescription = activityDescription;
            AllocationDescription = allocationDescription;
            AmendmentReason = amendmentReason;
            InvestmentPriority = investmentPriority;
            AgreementNumber = agreementNumber;
            SpecificationTitle = specificationTitle;
            RegionType = regionType;
            LearningRatePremium = learningRatePremium;
        }

        public string AllocationNumber { get; }

        public DateTime? StartDate { get; }

        public DateTime? EndDate { get; }

        public string FundingStreamCode { get; }

        public string FundingStreamPeriodCode { get; }

        public string LepName { get; }

        public string LepCode { get; }

        public string TenderSpecReference { get; }

        public string LotReference { get; }

        public string TenderAwardReference { get; }

        public string ActivityDescription { get; }

        public string AllocationDescription { get; }

        public string AmendmentReason { get; }

        public string InvestmentPriority { get; }

        public string AgreementNumber { get; }

        public string SpecificationTitle { get; }

        public string RegionType { get; }

        public string LearningRatePremium { get; }
    }
}
