namespace ContractManagement.DataStore.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IEngagementEventRepository
    {
        long GetMaxEventId(ConnectionInfo connectionInfo);

        void AddRange(IEnumerable<EngagementEvent> engagementEvents, ConnectionInfo connectionInfo);

        Task<EngagementEvent> GetById(long eventId, ConnectionInfo connectionInfo);

        IReadOnlyCollection<string> FindProvidersAlreadyInFlight(IReadOnlyCollection<EngagementEvent> engagementEvents, ConnectionInfo connectionInfo);

        Task<IReadOnlyCollection<EngagementEvent>> FindEventsWhereProviderIsNotFound();

        Task<IReadOnlyCollection<EngagementEvent>> FindEventsWhereProviderIsNotFound(ConnectionInfo connectionInfo);

        void SaveChanges();

        Task MarkEventsAsDuplicate(IReadOnlyCollection<long> eventIds, ConnectionInfo connectionInfo);

        Task Update(long eventId, string contractNumber, EngagementEventProcessingState processingState,
            ConnectionInfo connectionInfo);
    }
}