namespace PerformanceManagementDomain.PullFundingClaim.Repositories
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.Entity;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using DTOs;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public class FundingClaimRepository : IFundingClaimRepository
    {
        public async Task AddFundingClaims(IReadOnlyCollection<FundingClaim> fundingClaims, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo))
            {
                context.FundingClaims.AddRange(fundingClaims);
                await context.SaveChangesAsync()
                    .ConfigureAwait(false);
            }
        }

        public async Task<int> GetCountOfFundingClaimsForCollection(string period, string claimTypeName, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo))
            {
                return await context.FundingClaims.CountAsync(fc => fc.ClaimTypeName == claimTypeName && fc.Period == period)
                    .ConfigureAwait(false);
            }
        }

        public async Task<IReadOnlyCollection<FundingClaimKey>> GetKeys(string period, string claimTypeName,
            ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo))
            {
                var rows = await context.FundingClaims.ToListAsync();

                var lstkeys = (from res in rows
                               where res.Period==period && res.ClaimTypeName==claimTypeName
                               select new FundingClaimKey
                               { 
                               OrganisationIdentifier=res.OrganisationIdentifier,
                               VersionNumber=res.VersionNumber,
                               ClaimTypeName=res.ClaimTypeName,
                               PeriodTypeCode=res.PeriodTypeCode,
                               Period=res.Period
                               }).ToList();
                return lstkeys;
            }
        }
    }
}