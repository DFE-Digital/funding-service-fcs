namespace ContractManagement.Cfs.Repositories
{
    using System.Collections.Concurrent;
    using DataStore;
    using DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class FundingTypeFundingPeriodQueryRepository : IFundingTypeFundingPeriodQueryRepository
    {
        private readonly ConcurrentDictionary<(string FundingTypeCode, string FundingPeriodName), FundingTypeFundingPeriod> FundingTypeFundingPeriods
            = new ConcurrentDictionary<(string FundingTypeCode, string FundingPeriodName), FundingTypeFundingPeriod>();

        public FundingTypeFundingPeriod Get(ConnectionInfo connectionInfo, string fundingTypeCode,
            string fundingPeriodName)
        {
            return FundingTypeFundingPeriods.GetOrAdd((fundingTypeCode, fundingPeriodName), GetFromDb(connectionInfo, fundingTypeCode, fundingPeriodName));
        }

        private static FundingTypeFundingPeriod GetFromDb(ConnectionInfo connectionInfo, string fundingTypeCode,
            string fundingPeriodName)
        {
            using (var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return context.FundingTypeFundingPeriodItems.Find(fundingTypeCode, fundingPeriodName);
            }
        }
    }
}
