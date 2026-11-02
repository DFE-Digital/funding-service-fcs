namespace FundingAllocation.Endpoints.ReleaseGroup.Repositories
{
    using System.Threading.Tasks;

    public interface ICrmReleaseGroupRepository
    {
        Task SetToAwaitingRelease(string crmEntityId);
    }
}