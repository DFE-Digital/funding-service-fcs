namespace ContractCreateDomain.IncrementContractVersionEndpoint.Repositories
{
    using System.Collections.Concurrent;
    using System.Data.Entity;
    using System.Threading.Tasks;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class FundingTypeFundingPeriodQueryRepository : IFundingTypeFundingPeriodQueryRepository
    {
        private static readonly ConcurrentDictionary<string, FundingTypeFundingPeriod> FundingTypeFundingPeriods 
            = new ConcurrentDictionary<string, FundingTypeFundingPeriod>();

        public async Task<FundingTypeFundingPeriod> Get(string fundingTypeCode, string fundingPeriod, ConnectionInfo connectionInfo)
        {
            string key = CreateKey(fundingTypeCode, fundingPeriod);

            if (!FundingTypeFundingPeriods.ContainsKey(key))
            {
                var fundingTypeFundingPeriod = await GetFromDb(fundingTypeCode, fundingPeriod, connectionInfo);

                FundingTypeFundingPeriods.TryAdd(key, fundingTypeFundingPeriod);

                return fundingTypeFundingPeriod;
            }

            return FundingTypeFundingPeriods[key];
        }

        private static string CreateKey(string fundingTypeCode, string fundingPeriod)
        {
            return $"{fundingTypeCode}____{fundingPeriod}";
        }

        private async Task<FundingTypeFundingPeriod> GetFromDb(string fundingTypeCode, string fundingPeriod,
            ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return await context.FundingTypeFundingPeriodItems.SingleAsync(ftfp =>
                        ftfp.FundingTypeCode == fundingTypeCode && ftfp.FundingPeriodName == fundingPeriod)
                    .ConfigureAwait(continueOnCapturedContext: false);
            }
        }
    }
}