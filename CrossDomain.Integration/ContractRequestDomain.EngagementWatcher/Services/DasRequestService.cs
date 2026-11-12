namespace SFA.FCT.ContractRequestDomain.EngagementWatcher.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class DasRequestService : IDasRequestService
    {
        private const string LevyFundingType = "LEVY";
        private const string LevyFundingPeriod = "LEVY1799";
        private const int HighestManuallyProcessedEventId = 33843;

        private readonly IEngagementEventRepository _engagementEventRepository;
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;
        private readonly IDasEventsApiAdapter _dasEventsApiAdapter;
        private readonly ILogger _logger;

        public DasRequestService(
            IEngagementEventRepository engagementEventRepository,
            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository,
            IDasEventsApiAdapter dasEventsApiAdapter,
            ILogger logger)
        {
            _logger = logger;
            _engagementEventRepository = engagementEventRepository;
            _dasEventsApiAdapter = dasEventsApiAdapter;
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
        }

        public async Task<DasRequestsResult> GetLatestDasRequests(int numberOfItemsToRetrieve, ConnectionInfo connectionInfo)
        {
            long fromEventId = GetHighestProcessedEventId(connectionInfo) + 1;

            IReadOnlyCollection<EngagementEvent> latestEngagementEvents = _dasEventsApiAdapter.GetEngagementEventsAfterId(fromEventId, numberOfItemsToRetrieve);

            _engagementEventRepository.AddRange(latestEngagementEvents, connectionInfo);

            EngagementEventValidator.Validate(latestEngagementEvents);
            
            await LogValidationErrors(latestEngagementEvents.Where(e => !e.IsValid), connectionInfo);

            List<EngagementEvent> validEngagementEvents = latestEngagementEvents.Where(e => e.IsValid).ToList();

            validEngagementEvents = await FilterOutDuplicateProviders(validEngagementEvents, connectionInfo);

            return new DasRequestsResult(
                latestEngagementEvents.Count,
                TransformToDasRequests(validEngagementEvents));
        }

        private long GetHighestProcessedEventId(ConnectionInfo connectionInfo)
        {
            long highestStoredEventId = _engagementEventRepository.GetMaxEventId(connectionInfo);

            return Math.Max(highestStoredEventId, HighestManuallyProcessedEventId);
        }

        public async Task<DasRequestsResult> GetProviderNotFoundEvents(ConnectionInfo connectionInfo)
        {
            IReadOnlyCollection<EngagementEvent> providerNotFoundEvents =
                await _engagementEventRepository.FindEventsWhereProviderIsNotFound(connectionInfo);

            var providerNotFoundGrps = providerNotFoundEvents.GroupBy(e => e.ProviderId).Select(grp =>
            {
                var eventsForTheSameProvider = grp.OrderBy(e => e.CreatedDate).ToList();

                return new {Oldest = eventsForTheSameProvider.First(), Duplicates = eventsForTheSameProvider.Skip(1).Select(e => e.EventId)};
            }).ToList();

            var duplicateEvents = providerNotFoundGrps.SelectMany(grp => grp.Duplicates).ToList();

            providerNotFoundEvents = providerNotFoundGrps.Select(grp => grp.Oldest).ToList();

            return new DasRequestsResult(providerNotFoundEvents.Count, TransformToDasRequests(providerNotFoundEvents), duplicateEvents: duplicateEvents);
        }

        private async Task<List<EngagementEvent>> FilterOutDuplicateProviders(List<EngagementEvent> engagementEvents, ConnectionInfo connectionInfo)
        {
            IReadOnlyCollection<string> matchingProvidersInFlight = _engagementEventRepository.FindProvidersAlreadyInFlight(engagementEvents, connectionInfo);

            var alreadyInFlightEvents = engagementEvents.Where(ee => matchingProvidersInFlight.Contains(ee.ProviderId)).ToList();

            await _engagementEventRepository.MarkEventsAsDuplicate(alreadyInFlightEvents.Select(e => e.EventId).ToList(),
                connectionInfo);

            var providerGroups = engagementEvents.GroupBy(ee => ee.ProviderId).ToList();

            // set the duplicate flag on all but the first provider in each group
            var duplicates = providerGroups.SelectMany(g => g.Skip(1).Select(e => e.EventId)).ToList();
            await _engagementEventRepository.MarkEventsAsDuplicate(duplicates, connectionInfo);

            // now remove these from the collection
            providerGroups.RemoveAll(g => alreadyInFlightEvents.Select(aife => aife.ProviderId).Contains(g.Key));

            // return the first provider in each group
            return providerGroups.Select(g => g.First()).ToList();
        }

        private async Task LogValidationErrors(IEnumerable<EngagementEvent> failedEngagementEvents, ConnectionInfo connectionInfo)
        {
            foreach (var failure in failedEngagementEvents)
            {
                _logger.LogInformation(ContractRequestDomainEventLoggingId.DasRequestTransformerValidationFailure,
                    failure.ValidationError);

                await _engagementEventRepository.Update(failure.EventId, null, EngagementEventProcessingState.Invalid,
                    connectionInfo);
            }
        }

        private IReadOnlyCollection<DasRequest> TransformToDasRequests(IEnumerable<EngagementEvent> engagementEvents)
        {
            FundingTypeFundingPeriod fundingTypePolicy = _fundingTypeFundingPeriodQueryRepository.Get(LevyFundingType, LevyFundingPeriod);

            return engagementEvents
                .Select(e => new DasRequest
                {
                    FundingType = LevyFundingType,
                    StartDate = DateTime.SpecifyKind(fundingTypePolicy.DefaultContractStartDate.Value, DateTimeKind.Utc),
                    Ukprn = int.Parse(e.ProviderId),
                    DasEngagementEventId = e.EventId
                })
                .ToList();
        }
    }
}