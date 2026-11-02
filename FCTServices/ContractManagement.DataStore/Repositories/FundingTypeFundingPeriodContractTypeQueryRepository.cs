namespace ContractManagement.DataStore.Repositories
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Linq;
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class FundingTypeFundingPeriodContractTypeQueryRepository : IFundingTypeFundingPeriodContractTypeQueryRepository
    {
        private static readonly ConcurrentDictionary<string, Lazy<IReadOnlyCollection<FundingTypeFundingPeriodContractType>>> CachedFundingTypeFundingPeriodContractTypes = new ConcurrentDictionary<string, Lazy<IReadOnlyCollection<FundingTypeFundingPeriodContractType>>>();
        private const string CacheKeyAll = "ALL";
        
        public IReadOnlyCollection<FundingTypeFundingPeriodContractType> GetFundingTypeFundingPeriodContractTypes(ConnectionInfo connectionInfo)
        {
            var lazyFundingTypeFundingPeriodContractTypes = new Lazy<IReadOnlyCollection<FundingTypeFundingPeriodContractType>>(() => GetFundingTypeFundingPeriodContractTypesFromDb(connectionInfo));

            return CachedFundingTypeFundingPeriodContractTypes.GetOrAdd(CacheKeyAll, lazyFundingTypeFundingPeriodContractTypes).Value;
        }

        private IReadOnlyCollection<FundingTypeFundingPeriodContractType> GetFundingTypeFundingPeriodContractTypesFromDb(ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return context.FundingTypeFundingPeriodContractTypes.ToList();
            }
        }
    }
}
