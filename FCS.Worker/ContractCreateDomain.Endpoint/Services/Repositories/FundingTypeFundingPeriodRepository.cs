namespace ContractCreateDomain.Endpoint.Services.Repositories
{
    using System.Collections.Concurrent;
    using System.Data.Entity;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class FundingTypeFundingPeriodRepository : IFundingTypeFundingPeriodRepository
    {
        private static readonly ConcurrentDictionary<string, FundingTypeFundingPeriod> CachedFundingTypeFundingPeriod =
            new ConcurrentDictionary<string, FundingTypeFundingPeriod>();

        public async Task<bool> ShouldIncludeAllContractsOnSummaryOfFunding(string fundingTypeCode, string fundingPeriod, ConnectionInfo connectionInfo)
        {
            var key = fundingTypeCode + "___" + fundingPeriod;

            if (!CachedFundingTypeFundingPeriod.ContainsKey(key))
            {
                var fundingTypeFundingPeriod = 
                    await GetFundingTypeFundingPeriodFromDb(fundingTypeCode, fundingPeriod, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

                CachedFundingTypeFundingPeriod.TryAdd(key, fundingTypeFundingPeriod);

                return fundingTypeFundingPeriod.IncludeAllContractsOnSummaryOfFunding;
            }

            return CachedFundingTypeFundingPeriod[key].IncludeAllContractsOnSummaryOfFunding;
        }

        private static async Task<FundingTypeFundingPeriod> GetFundingTypeFundingPeriodFromDb(string fundingTypeCode, string fundingPeriod, ConnectionInfo connectionInfo)
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return await context.FundingTypeFundingPeriodItems
                    .Where(ftfp => ftfp.FundingTypeCode == fundingTypeCode && ftfp.FundingPeriodName == fundingPeriod)
                    .SingleAsync()
                    .ConfigureAwait(continueOnCapturedContext: false);
            }
        }
    }
}