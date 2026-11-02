namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using System.Threading.Tasks;
    using DataStore;
    using Dto;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class HeldFspCollectionConfigRepository: IHeldFspCollectionConfigRepository
    {
        private static readonly ConcurrentDictionary<string, Lazy<Task<IReadOnlyCollection<IReadOnlyCollection<CollectionReturn>>>>> CachedHeldFspCollectionConfigs
            = new ConcurrentDictionary<string, Lazy<Task<IReadOnlyCollection<IReadOnlyCollection<CollectionReturn>>>>>();

        public async Task<IReadOnlyCollection<IReadOnlyCollection<CollectionReturn>>> GetCollectionReturns(ConnectionInfo connectionInfo, string fundingStreamPeriodCode)
        {
            Lazy<Task<IReadOnlyCollection<IReadOnlyCollection<CollectionReturn>>>> lazyTaskGetHeldFspCollectionConfigs
                = new Lazy<Task<IReadOnlyCollection<IReadOnlyCollection<CollectionReturn>>>>(() =>
                      GetConfigFromDb(connectionInfo, fundingStreamPeriodCode));

            lazyTaskGetHeldFspCollectionConfigs = CachedHeldFspCollectionConfigs.GetOrAdd(fundingStreamPeriodCode, lazyTaskGetHeldFspCollectionConfigs);

            return await lazyTaskGetHeldFspCollectionConfigs.Value;
        }

        private async Task<IReadOnlyCollection<IReadOnlyCollection<CollectionReturn>>> GetConfigFromDb(
            ConnectionInfo connectionInfo, string fundingStreamPeriodCode)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return await GetConfigFromDb(context, fundingStreamPeriodCode);
            }
        }
        private static async Task<IReadOnlyCollection<IReadOnlyCollection<CollectionReturn>>> GetConfigFromDb(MonitoringDeliverablesDbContext context, string fundingStreamPeriodCode)
        {
            var groups = await context.HeldFspCollectionConfigs
                .AsNoTracking()
                .Where(config => config.FundingStreamPeriodCode == fundingStreamPeriodCode)
                .Select(h => new { h.MultipleCollectionGroupId, h.CollectionType, h.CollectionReturnCode })
                .GroupBy(config1 => config1.MultipleCollectionGroupId)
                .ToListAsync();

            return groups.Select(g => g.Select(r => new CollectionReturn(r.CollectionReturnCode, r.CollectionType)).ToList()).ToList();
        }
    }
}