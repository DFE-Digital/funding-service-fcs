namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Services
{
    using System;
    using System.Linq;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using Framework.Logging.Interfaces;

    public class FundingTypePeriodService : IFundingTypePeriodService
    {
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypePeriodQueryRepository;
        private readonly ILogger _logger;

        public FundingTypePeriodService(IFundingTypeFundingPeriodQueryRepository fundingTypePeriodQueryRepository,
            ILogger logger)
        {
            _fundingTypePeriodQueryRepository = fundingTypePeriodQueryRepository;
            _logger = logger;
        }

        public void EnrichContract(ExtendedContractType extendedContract)
        {
            var firstContract = extendedContract.contracts.First();
            var fundingTypeCode = firstContract.fundingType.fundingTypeCode;
            var fundingPeriod = firstContract.period.GetFundingPeriodName();
            var fundingTypeFundingPeriod = _fundingTypePeriodQueryRepository.Get(fundingTypeCode, fundingPeriod);

            if (fundingTypeFundingPeriod == null)
            {
                _logger.LogError(ContractCreateDomainEventLoggingId.FundingTypePeriodNotFound,
                    "FundingTypePeriod not found for fundingTypeCode {0} fundingPeriod {1}", fundingTypeCode,
                    fundingPeriod);
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