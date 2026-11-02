namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload.FundingAllocationRelease.Repositories
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IFundingAllocationReleaseRepository
    {
        Task SetToReleaseInProgress(int releaseGroupGroupId, string fundingTypeCode, string fundingPeriodName, ConnectionInfo connectionInfo);

        Task SetToReleased(int releaseGroupGroupId, ConnectionInfo connectionInfo);
    }
}