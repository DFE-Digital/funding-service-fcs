namespace PerformanceManagementDomain.PullFundingClaim.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using DTOs;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public interface IFundingClaimRepository
    {
        Task AddFundingClaims(IReadOnlyCollection<FundingClaim> fundingClaims, ConnectionInfo connectionInfo);

        Task<int> GetCountOfFundingClaimsForCollection(string period, string claimTypeName, ConnectionInfo connectionInfo);

        Task<IReadOnlyCollection<FundingClaimKey>> GetKeys(string period, string claimTypeName,
            ConnectionInfo connectionInfo);
    }
}
