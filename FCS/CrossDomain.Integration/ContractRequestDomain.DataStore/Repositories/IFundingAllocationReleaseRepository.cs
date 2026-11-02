namespace SFA.FCT.ContractRequestDomain.DataStore.Repositories
{
    using CrossDomain.Integration.Entities.Data;

    public interface IFundingAllocationReleaseRepository
    {
        bool IsReleaseInProgress(string fundingTypeCode, string fundingPeriod, ConnectionInfo connectionInfo);
    }
}