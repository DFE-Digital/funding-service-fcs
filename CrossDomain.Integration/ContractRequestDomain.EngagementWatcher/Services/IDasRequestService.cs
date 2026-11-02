namespace ContractRequestDomain.EngagementWatcher.Services
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IDasRequestService
    {
        Task<DasRequestsResult> GetLatestDasRequests(int numberOfItemsToRetrieve, ConnectionInfo connectionInfo);

        Task<DasRequestsResult> GetProviderNotFoundEvents(ConnectionInfo connectionInfo);
    }
}
