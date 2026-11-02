namespace Operations.Web.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;

    public interface IRoatpUkprnRepository
    {
        IReadOnlyCollection<string> GetValidUkprns();
        Task<bool> GetStatusOfEngagmenetWatcherWebjob(string webjobname);
        Task UpdateStatusOfEngagementWatcherWebJobStatus(string webjobname, bool enabled, string username);
    }
}