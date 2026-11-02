namespace PerformanceManagementDomain.PullFundingClaim.Handlers
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using DTOs;
    using Extensions;
    using Infrastructure;
    using NServiceBus;
    using Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PerformanceManagementDomain.Common.Commands;
    using SFA.FCT.PerformanceManagementDomain.Common.Logging;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public class PullPageForPeriodClaimTypeHandler : IHandleMessages<PullPageForPeriodClaimTypeCommand>
    {
        private readonly ILogger _logger;
        private readonly IFundingClaimsApiAdapter _fundingClaimsApiAdapter;
        private readonly IFundingClaimImportInfoRepository _fundingClaimImportInfoRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IFundingClaimRepository _fundingClaimRepository;
        private readonly IDateProvider _dateProvider;
        private readonly IClaimReconciliationAllocationGroupFspRepository _claimReconciliationAllocationGroupFspRepository;

        public PullPageForPeriodClaimTypeHandler(
            ILogger logger,
            IFundingClaimsApiAdapter fundingClaimsApiAdapter,
            IFundingClaimImportInfoRepository fundingClaimImportInfoRepository,
            ISessionConnectionFactory sessionConnectionFactory,
            IFundingClaimRepository fundingClaimRepository,
            IDateProvider dateProvider,
            IClaimReconciliationAllocationGroupFspRepository claimReconciliationAllocationGroupFspRepository)
        {
            _logger = logger;
            _fundingClaimsApiAdapter = fundingClaimsApiAdapter;
            _fundingClaimImportInfoRepository = fundingClaimImportInfoRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
            _fundingClaimRepository = fundingClaimRepository;
            _dateProvider = dateProvider;
            _claimReconciliationAllocationGroupFspRepository = claimReconciliationAllocationGroupFspRepository;
        }

        public async Task Handle(PullPageForPeriodClaimTypeCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                PerformanceManagementLoggingId.PullPageForPeriodClaimTypeCommandArrived,
                $"PullPageForPeriodClaimTypeCommand arrived for {message}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            IReadOnlyCollection<FundingClaimApiDto> fundingClaimDtos =
                await _fundingClaimsApiAdapter.GetFundingClaimsForCollectionKey(message.PeriodClaimType, message.PageNumber)
                    .ConfigureAwait(false);

            await RemoveInvalidAllocations(fundingClaimDtos, connectionInfo)
                .ConfigureAwait(false);

            IReadOnlyCollection<FundingClaim> fundingClaims = fundingClaimDtos.Select(dto => dto.ToDataModel()).ToList();

            if (fundingClaims.Any())
            {
                string period = fundingClaims.First().Period;
                string claimTypeName = fundingClaims.First().ClaimTypeName;

                await _fundingClaimRepository.AddFundingClaims(fundingClaims, connectionInfo)
                    .ConfigureAwait(false);

                FundingClaimCollectionImportInfo collectionInfo = await _fundingClaimImportInfoRepository.Find(message.PeriodClaimType, connectionInfo)
                    .ConfigureAwait(false);

                int numberOfRowsImported = await _fundingClaimRepository.GetCountOfFundingClaimsForCollection(period, claimTypeName, connectionInfo)
                    .ConfigureAwait(false);

                if (numberOfRowsImported <= collectionInfo.TotalRowsToImport)
                {
                    if (IsLastPage(collectionInfo, numberOfRowsImported))
                    {
                        await _fundingClaimImportInfoRepository.SetToComplete(
                            periodClaimType:collectionInfo.PeriodClaimType,
                            completedDate:_dateProvider.GetDate(connectionInfo),
                            connectionInfo:connectionInfo).ConfigureAwait(false);

                        await context.Send(new ProcessFundingClaimsCommand(period, claimTypeName))
                            .ConfigureAwait(false);

                        _logger.LogInformation(
                            PerformanceManagementLoggingId.PullPageForPeriodClaimTypeLastPageStoredForCollection,
                            $"Last page of FundingClaims stored for {message}, processing triggered");
                    }
                }
                else
                {
                    _logger.LogError(PerformanceManagementLoggingId.TotalFundingClaimsImportedExceedsExpected,
                        $"The number of rows imported for {message} ({numberOfRowsImported}) is greater than the total expected of {collectionInfo.TotalRowsToImport}");
                }
            }

            _logger.LogInformation(
                PerformanceManagementLoggingId.PullPageForPeriodClaimTypeCommandProcessed,
                $"PullPageForPeriodClaimTypeCommand processed for {message}");
        }

        private async Task RemoveInvalidAllocations(IReadOnlyCollection<FundingClaimApiDto> fundingClaimDtos,
            ConnectionInfo connectionInfo)
        {
            IReadOnlyCollection<string> validFspCodes = await _claimReconciliationAllocationGroupFspRepository.GetValidFundingStreamPeriodCodes(connectionInfo)
                .ConfigureAwait(false);

            fundingClaimDtos
                .ToList()
                .ForEach(fc => fc.ContractAllocations = fc.ContractAllocations.Where(ca => validFspCodes.Contains(ca.FundingStreamPeriodCode)).ToList());
        }

        private static bool IsLastPage(FundingClaimCollectionImportInfo collectionInfo, int numberOfRowsImported)
        {
            return collectionInfo.TotalRowsToImport == numberOfRowsImported;
        }
    }
}
