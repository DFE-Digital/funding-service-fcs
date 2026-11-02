namespace FundingAllocation.Repositories
{
    using System.Threading.Tasks;

    public interface ICrmReleaseGroupRepository
    {
        Task CreateReleaseGroup(
            string releaseGroupName,
            string fundingTypeId,
            string fundingPeriodId,
            string fspGroupId,
            string contractTypeId,
            string crmReleaseGroupEntityId);
    }
}