namespace ContractManagement.DataStore.Repositories
{
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System;
    using System.Linq;

    public class FundingTypeFundingPeriodQueryRepository : IFundingTypeFundingPeriodQueryRepository
    {
        private readonly IContractManagementDbContext _dbContext;
        private readonly IEntityCache<(string FundingTypeCode, string FundingPeriodName), FundingTypeFundingPeriod> _entityCache;

        public FundingTypeFundingPeriodQueryRepository(IContractManagementDbContext dbContext, IEntityCache<(string, string), FundingTypeFundingPeriod> entityCache)
        {
            _dbContext = dbContext;
            _entityCache = entityCache;
        }

        public FundingTypeFundingPeriod Get(string fundingTypeCode, string fundingPeriodName)
        {
            return Get(fundingTypeCode, fundingPeriodName, _dbContext);
        }

        public FundingTypeFundingPeriod Get(string fundingTypeCode, string fundingPeriodName, ConnectionInfo connectionInfo)
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return Get(fundingTypeCode, fundingPeriodName, context);
            }
        }

        private FundingTypeFundingPeriod Get(string fundingTypeCode, string fundingPeriodName, IContractManagementDbContext dbContext)
        {
            return _entityCache.GetOrAdd(
                (fundingTypeCode, fundingPeriodName), 
                key => dbContext.FundingTypeFundingPeriodItems.Find(key.FundingTypeCode, key.FundingPeriodName));
        }

        public bool IsFundingTypeFundingPeriodAllowedToHaveDeliveryOrg(string fundingTypeCode, string fundingPeriodName)
        {
            return Get(fundingTypeCode, fundingPeriodName).AllowUseOfDeliveryOrgs;
        }

        public static FundingTypeFundingPeriodQueryRepository CreateInstance(IContractManagementDbContext dbContext)
        {
            return new FundingTypeFundingPeriodQueryRepository(dbContext, new EntityCache<(string, string), FundingTypeFundingPeriod>());
        }

        public bool IsLEVYAllocationSynced(string contractNo, int contractversionNo, int contractsubversionNo, int allocationCount)
        {
            return CheckAllocaions(contractNo, contractversionNo, contractsubversionNo, allocationCount);
        }

        private bool CheckAllocaions(string contractNo, int contractversionNo, int contractsubversionNo, int allocationCount)
        {
            using (var context = new ContractManagementDbContext())
            {
                try
                {
                    int? storedAllocationCount = context.CreatedContracts.SingleOrDefault(c =>
                        c.ContractNumber == contractNo && c.ContractVersionNumber == contractversionNo &&
                        c.ContractSubVersionNumber == contractsubversionNo)
                        .TotalAllocationCount;

                    return storedAllocationCount == allocationCount;
                }
                catch
                {
                    return false;
                }
            }
        }
    }
}