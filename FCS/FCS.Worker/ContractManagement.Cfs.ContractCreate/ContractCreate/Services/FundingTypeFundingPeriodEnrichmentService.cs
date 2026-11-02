namespace ContractManagement.Cfs.ContractCreate.Services
{
    using System;
    using System.Linq;
    using Cfs.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class FundingTypeFundingPeriodEnrichmentService : IFundingTypeFundingPeriodEnrichmentService
    {
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypePeriodQueryRepository;

        public FundingTypeFundingPeriodEnrichmentService(IFundingTypeFundingPeriodQueryRepository fundingTypePeriodQueryRepository)
        {
            _fundingTypePeriodQueryRepository = fundingTypePeriodQueryRepository;
        }

        public void EnrichContract(ConnectionInfo connectionInfo, ExtendedContractType extendedContract)
        {
            var firstContract = extendedContract.contracts.First();
            var fundingTypeCode = firstContract.fundingType.fundingTypeCode;
            var fundingPeriod = firstContract.period.GetFundingPeriodName();
            var fundingTypeFundingPeriod = _fundingTypePeriodQueryRepository.Get(connectionInfo, fundingTypeCode, fundingPeriod);

            if (fundingTypeFundingPeriod == null)
            {
                throw new ArgumentException(
                    $"FundingTypePeriod not found for fundingTypeCode {fundingTypeCode} fundingPeriod {fundingPeriod}");
            }

            firstContract.SkipCaseloadAssignment = fundingTypeFundingPeriod.SkipCaseloadAssignment;
            firstContract.SkipReviewAndInternalApproval = fundingTypeFundingPeriod.SkipReviewAndInternalApproval;
            firstContract.DocumentationRequired = fundingTypeFundingPeriod.DocumentsRequired;
            firstContract.SkipDocumentMerge = fundingTypeFundingPeriod.SkipDocumentMerge;
        }
    }
}
