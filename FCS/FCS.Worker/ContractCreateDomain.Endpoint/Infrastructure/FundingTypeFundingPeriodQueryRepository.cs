namespace ContractCreateDomain.Endpoint.Infrastructure
{
    using System.Collections.Concurrent;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class FundingTypeFundingPeriodQueryRepository : IFundingTypeFundingPeriodQueryRepository
    {
        private static readonly ConcurrentDictionary<string, FundingTypeFundingPeriod> FundingTypeFundingPeriods = new ConcurrentDictionary<string, FundingTypeFundingPeriod>();

        public FundingTypeFundingPeriod Get(string fundingTypeCode, string fundingPeriod, ConnectionInfo connectionInfo)
        {
            return FundingTypeFundingPeriods.GetOrAdd(CreateKey(fundingTypeCode, fundingPeriod),
                k => GetFromDb(fundingTypeCode, fundingPeriod, connectionInfo));
        }

        private string CreateKey(string fundingTypeCode, string fundingPeriod)
        {
            return $"{fundingTypeCode}____{fundingPeriod}";
        }

        private FundingTypeFundingPeriod GetFromDb(string fundingTypeCode, string fundingPeriod,
            ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return context.FundingTypeFundingPeriodItems.Single(ftfp =>
                    ftfp.FundingTypeCode == fundingTypeCode && ftfp.FundingPeriodName == fundingPeriod);
            }
        }
    }
}
