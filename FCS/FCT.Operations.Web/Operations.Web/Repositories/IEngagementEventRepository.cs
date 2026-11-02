namespace Operations.Web.Repositories
{
    using System.Collections.Generic;
    using Dtos;
    using System.Threading.Tasks;

    public interface IEngagementEventRepository
    {
        Task<InsertResult> AddIfNotAlreadyAdded(string providerId);

        Task<IReadOnlyCollection<EngagementEventInfo>> GetRecentEngagementEvents();
    }
}