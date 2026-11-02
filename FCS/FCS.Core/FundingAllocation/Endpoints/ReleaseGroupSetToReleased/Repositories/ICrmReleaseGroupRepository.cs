namespace FundingAllocation.Endpoints.ReleaseGroupSetToReleased.Repositories
{
    using System.Threading.Tasks;

    public interface ICrmReleaseGroupRepository
    {
        Task SetToReleased(string crmReleaseGroupEntityId);
    }
}