namespace PerformanceManagementDomain.PullFundingClaim.Repositories
{
    using System;
    using System.Data.Entity;
    using System.Linq;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public class FundingClaimImportInfoRepository : IFundingClaimImportInfoRepository
    {
        public async Task<DateTime> GetLastCompletedImportDateOrDefault(ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo: connectionInfo))
            {
                var lastCompletedImportDate = await context.FundingClaimCollectionImportInfos
                    .Select(f => f.ImportCompletedDate)
                    .OrderByDescending(d => d)
                    .FirstOrDefaultAsync()
                    .ConfigureAwait(false);

                return lastCompletedImportDate.GetValueOrDefault(DateTime.MinValue);
            }
        }

        public async Task Add(string periodClaimType, int totalRows, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo:connectionInfo))
            {
                context.FundingClaimCollectionImportInfos.Add(
                        new FundingClaimCollectionImportInfo(periodClaimType)
                        {
                            TotalRowsToImport = totalRows
                        });

                await context.SaveChangesAsync();
            }
        }

        public async Task SetToComplete(string periodClaimType, DateTime completedDate, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo: connectionInfo))
            {
                var existingRow =
                    await context.FundingClaimCollectionImportInfos.SingleAsync(f =>
                        f.PeriodClaimType == periodClaimType).ConfigureAwait(false);

                existingRow.ImportCompletedDate = completedDate;
                
                await context.SaveChangesAsync();
            }
        }

        public async Task<FundingClaimCollectionImportInfo> Find(string periodClaimType, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo: connectionInfo))
            {
                return await context.FundingClaimCollectionImportInfos
                    .SingleAsync(f => f.PeriodClaimType == periodClaimType)
                    .ConfigureAwait(false);
            }
        }
    }
}
