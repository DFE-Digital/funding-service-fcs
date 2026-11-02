namespace AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint.Repositories
{
    using System.Data.Entity;
    using System.Threading.Tasks;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class FundingStreamPeriodRepository : IFundingStreamPeriodRepository
    {
        public async Task<FundingStreamPeriod> GetFundingStreamPeriod(ConnectionInfo connectionInfo, string fundingStreamPeriodCode)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                 return await context.FundingStreamPeriods
                    .FirstAsync(fsp => fsp.Code == fundingStreamPeriodCode)
                    .ConfigureAwait(continueOnCapturedContext: false);
            }
        }
    }
}