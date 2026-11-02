namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using Models;

    public interface IClaimTypeRepository
    {
        ClaimType FindByName(string claimTypeName);
    }
}
