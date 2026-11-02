namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using System.Threading.Tasks;
    using DTOs;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using Extensions;

    public class FspDeliverableClaimRepository : IFspDeliverableClaimRepository
    {
        public async Task<IReadOnlyCollection<FspDeliverableClaim>> GetFspDeliverablesIncludingClaimDeliverableGroup(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return await context.FspDeliverableClaims.Where(fspDel => fspDel.FspCode == fundingStreamPeriodCode
                                                                          && fspDel.ClaimReconciliationDeliverableGroupCode != null)
                    .Include(x => x.ClaimReconciliationDeliverableGroup).ToListAsync().ConfigureAwait(continueOnCapturedContext: false);
            }
        }

        public async Task<string> GetDeliverableName(int deliverableCode, string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return await context.FspDeliverableClaims
                    .Where(d => d.FspCode == fundingStreamPeriodCode && d.DeliverableCode == deliverableCode)
                    .Select(d => d.DeliverableName).SingleAsync().ConfigureAwait(continueOnCapturedContext: false);
            }
        }

        public async Task<IReadOnlyCollection<DeliverableCodeInfo>> GetDeliverableCodeInfos(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                var deliverableInfos = await context.FspDeliverableClaims.Where(fspDel => fspDel.FspCode == fundingStreamPeriodCode)
                    .Select(d => new {d.DeliverableCode, d.ParentDeliverableCode, d.AllowProfile, d.ClaimReconciliationDeliverableGroupCode})
                    .ToListAsync()
                    .ConfigureAwait(continueOnCapturedContext: false);


                return deliverableInfos.Select(d => new DeliverableCodeInfo(d.DeliverableCode, d.ParentDeliverableCode, d.ClaimReconciliationDeliverableGroupCode, d.AllowProfile))
                    .ToList();
            }
        }

        public async Task<IReadOnlyCollection<int>> GetProfileDeliverableCodes(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return await context.FspDeliverableClaims.Where(fspDel => fspDel.FspCode == fundingStreamPeriodCode &&
                                                                                          fspDel.AllowProfile)
                    .Select(d => d.DeliverableCode)
                    .ToListAsync()
                    .ConfigureAwait(continueOnCapturedContext: false);
            }
        }

        public decimal GetSumOfParentDeliverablesPlannedValueForGroup(IReadOnlyCollection<DeliverableLine> deliverableLines,
            IReadOnlyCollection<DeliverableCodeInfo> deliverableCodeInfos)
        {
            return deliverableLines.GetSumOfParentDeliverablesPlannedValueForGroup(deliverableCodeInfos);
        }
    }
}