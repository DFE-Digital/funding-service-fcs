namespace ContractCreateDomain.IncrementContractVersionEndpoint.Services
{
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System;
    using System.Linq;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using Repositories;
    using System.Threading.Tasks;
    
    public class FundingTypePeriodService : IFundingTypePeriodService
    {
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypePeriodQueryRepository;
        private readonly ILogger _logger;

        public FundingTypePeriodService(IFundingTypeFundingPeriodQueryRepository fundingTypePeriodQueryRepository, ILogger logger)
        {
            _fundingTypePeriodQueryRepository = fundingTypePeriodQueryRepository;
            _logger = logger;
        }

        public async Task EnrichContract(ExtendedContractType extendedContract, ConnectionInfo connectionInfo)
        {
            var firstContract = extendedContract.contracts.First();
            var fundingTypeCode = firstContract.fundingType.fundingTypeCode;
            var fundingPeriod = firstContract.period.GetFundingPeriodName();
            var fundingTypeFundingPeriod = await _fundingTypePeriodQueryRepository
                .Get(fundingTypeCode, fundingPeriod, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

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