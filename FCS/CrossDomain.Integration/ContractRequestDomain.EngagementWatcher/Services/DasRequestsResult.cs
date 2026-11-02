namespace ContractRequestDomain.EngagementWatcher.Services
{
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using System.Linq;

    public class DasRequestsResult
    {
        public DasRequestsResult(int totalEventsReceived, IReadOnlyCollection<DasRequest> initiatedEngagementEventsReceived, IReadOnlyCollection<long> duplicateEvents = null)
        {
            TotalEventsReceived = totalEventsReceived;
            InitiatedEngagementEventsReceived = initiatedEngagementEventsReceived;
            DuplicateEvents = duplicateEvents ?? new List<long>();
        }

        public int TotalEventsReceived { get; }

        public IReadOnlyCollection<DasRequest> InitiatedEngagementEventsReceived { get; }

        public IReadOnlyCollection<long> DuplicateEvents { get; }
        
        public override string ToString()
        {
            var initiatedEventIds = InitiatedEngagementEventsReceived.Select(ieer => ieer.DasEngagementEventId).ToList();
            return $"InitiatedEvents: {string.Join(" ,", initiatedEventIds)}. DuplicateEvents: {string.Join(" ,", DuplicateEvents)}";
        }
    }
}
