namespace ContractManagement.DataStore.Repositories
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using Model;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class EngagementEventRepository : IEngagementEventRepository
    {
        private readonly IContractManagementDbContext _context;

        public EngagementEventRepository(IContractManagementDbContext context)
        {
            _context = context;
        }

        public long GetMaxEventId(ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo))
            {
                return context.EngagementEvents.Select(engagementEvent => engagementEvent.EventId)
                    .DefaultIfEmpty()
                    .Max();
            }
        }

        public void AddRange(IEnumerable<EngagementEvent> engagementEvents, ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo))
            {
                engagementEvents.ForEach(engagementEvent => context.EngagementEvents.Add(engagementEvent));
                context.SaveChanges();
            }
        }

        public async Task<EngagementEvent> GetById(long eventId, ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return await context.EngagementEvents.SingleAsync(ee => ee.EventId == eventId);
            }
        }

        public async Task Update(long eventId, string contractNumber, EngagementEventProcessingState processingState, ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                var engagementEvent = await context.EngagementEvents.SingleAsync(ee => ee.EventId == eventId);
                engagementEvent.ContractNumber = contractNumber;
                engagementEvent.ProcessingState = processingState;

                await context.SaveChangesAsync();
            }
        }

        public IReadOnlyCollection<string> FindProvidersAlreadyInFlight(IReadOnlyCollection<EngagementEvent> engagementEvents, ConnectionInfo connectionInfo)
        {
            IReadOnlyCollection<long> engagementEventIds = engagementEvents.Select(ee => ee.EventId).ToList();
            IReadOnlyCollection<string> providerIds = engagementEvents.Select(ee => ee.ProviderId).ToList();
            using (var context = new ContractManagementDbContext(connectionInfo))
            {
                IQueryable<string> otherInFlightProviders = context.EngagementEvents.Where(
                        eeInDb => eeInDb.ProcessingState == EngagementEventProcessingState.InFlight &&
                                  !engagementEventIds.Contains(eeInDb.EventId))
                    .Select(ee => ee.ProviderId);

                return otherInFlightProviders.Where(otherProvider => providerIds.Contains(otherProvider)).ToList();
            }
        }

        public async Task<IReadOnlyCollection<EngagementEvent>> FindEventsWhereProviderIsNotFound()
        {
            return await 
                _context.EngagementEvents
                    .AsNoTracking()
                    .Where(e => e.ProcessingState == EngagementEventProcessingState.ProviderNotFound)
                    .ToListAsync();
        }

        public async Task<IReadOnlyCollection<EngagementEvent>> FindEventsWhereProviderIsNotFound(ConnectionInfo connectionInfo)
        {
            return await new EngagementEventRepository(new ContractManagementDbContext(connectionInfo.Connection,
                connectionInfo.Transaction)).FindEventsWhereProviderIsNotFound();
        }

        public async Task MarkEventsAsDuplicate(IReadOnlyCollection<long> eventIds, ConnectionInfo connectionInfo)
        {
            EngagementEventProcessingState processingState = EngagementEventProcessingState.Duplicate;

            var markEventsAsDuplicate = await _context.EngagementEvents.Where(ee => eventIds.Contains(ee.EventId)).ToListAsync();            if (markEventsAsDuplicate!=null)
            {
                markEventsAsDuplicate.ForEach(r => r.ProcessingState = processingState);
                _context.SaveChanges();
            }
        }

        public void SaveChanges()
        {
            _context.SaveChanges();
        }
    }
}
