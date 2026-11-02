namespace ContractCreateDomain.IncrementContractVersionEndpoint.Repositories
{
    using System;
    using System.Collections.Concurrent;
    using System.Data.Entity;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class FundingStreamPeriodRepository : IFundingStreamPeriodRepository
    {
        private static readonly ConcurrentDictionary<string, FundingStreamPeriod> FundingStreamPeriods 
            = new ConcurrentDictionary<string, FundingStreamPeriod>();

        public async Task<FundingStreamPeriod> Find(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            return FundingStreamPeriods.GetOrAdd(fundingStreamPeriodCode, 
                await GetFromDb(fundingStreamPeriodCode, connectionInfo));
        }

        private async Task<FundingStreamPeriod> GetFromDb(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                FundingStreamPeriod fundingStreamPeriod = await context.FundingStreamPeriods
                    .Where(fsp => fsp.FundingStreamPeriodCode == fundingStreamPeriodCode)
                    .Include(fsp => fsp.LegalDeliverables)
                    .AsNoTracking()
                    .SingleAsync()
                    .ConfigureAwait(continueOnCapturedContext: false);

                fundingStreamPeriod.StartDate = ToDateTimeWithSpecificKind(fundingStreamPeriod.StartDate, DateTimeKind.Utc);

                return fundingStreamPeriod;
            }
        }

        private static DateTime ToDateTimeWithSpecificKind(DateTime dt, DateTimeKind kind)
        {
            return new DateTime(dt.Year, dt.Month, dt.Day, dt.Hour, dt.Minute, dt.Second, kind);
        }
    }
}