namespace ContractRequestDomain.EngagementWatcher.Services
{
    using System.Collections.Generic;
    using ContractManagement.DataStore.Model;

    public interface IDasEventsApiAdapter
    {
        IReadOnlyCollection<EngagementEvent> GetEngagementEventsAfterId(long fromEventId, int pageSize);
        string BaseUrl { get; }
    }
}
