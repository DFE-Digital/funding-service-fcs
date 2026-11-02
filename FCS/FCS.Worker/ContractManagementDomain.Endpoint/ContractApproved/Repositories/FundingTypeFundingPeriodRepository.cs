namespace ContractManagementDomain.Endpoint.ContractApproved.Repositories
{
    using System.Collections.Concurrent;
    using System.Data.Entity;
    using System.Threading.Tasks;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class FundingTypeFundingPeriodRepository : IFundingTypeFundingPeriodRepository
    {
        private readonly ConcurrentDictionary<FundingTypeFundingPeriodKey, FundingTypeFundingPeriod> _cache = new ConcurrentDictionary<FundingTypeFundingPeriodKey, FundingTypeFundingPeriod>();

        public async Task<FundingTypeFundingPeriod> Get(string fundingTypeCode, string fundingPeriodName, ConnectionInfo connectionInfo)
        {
            FundingTypeFundingPeriodKey key = new FundingTypeFundingPeriodKey(fundingTypeCode, fundingPeriodName);

            if (!_cache.ContainsKey(key))
            {
                FundingTypeFundingPeriod entity = await GetEntityFromDatabase(fundingTypeCode, fundingPeriodName, connectionInfo)
                    .ConfigureAwait(false);
                _cache.TryAdd(key, entity);
            }

            return _cache[key];
        }

        private static async Task<FundingTypeFundingPeriod> GetEntityFromDatabase(string fundingTypeCode, string fundingPeriodName, ConnectionInfo connectionInfo)
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return await context.FundingTypeFundingPeriodItems
                    .FirstOrDefaultAsync(ftfp => ftfp.FundingTypeCode == fundingTypeCode && ftfp.FundingPeriodName == fundingPeriodName)
                    .ConfigureAwait(false);
            }
        }

        private class FundingTypeFundingPeriodKey
        {
            public FundingTypeFundingPeriodKey(string fundingTypeCode, string fundingPeriodName)
            {
                FundingTypeCode = fundingTypeCode;
                FundingPeriodName = fundingPeriodName;
            }

            private string FundingTypeCode { get; }

            private string FundingPeriodName { get; }

            public override bool Equals(object obj)
            {
                FundingTypeFundingPeriodKey other = obj as FundingTypeFundingPeriodKey;
                return FundingTypeCode == other?.FundingTypeCode && FundingPeriodName == other?.FundingPeriodName;
            }

            public override int GetHashCode()
            {
                return FundingTypeCode.GetHashCode() ^ FundingPeriodName.GetHashCode();
            }
        }
    }
}