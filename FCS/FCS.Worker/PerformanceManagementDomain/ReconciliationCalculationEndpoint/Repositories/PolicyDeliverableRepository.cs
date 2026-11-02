namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using System.Collections.Concurrent;

    public class PolicyDeliverableRepository : IPolicyDeliverableRepository
    {
        private static readonly ConcurrentDictionary<string, IReadOnlyCollection<PolicyDeliverable>> PolicyDeliverableCache =
            new ConcurrentDictionary<string, IReadOnlyCollection<PolicyDeliverable>>();

        public async Task<IReadOnlyCollection<PolicyDeliverable>> GetPolicyDeliverables(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            string key = fundingStreamPeriodCode;

            if (!PolicyDeliverableCache.ContainsKey(key))
            {
                var policyDeliverables = await GetFromDb(fundingStreamPeriodCode, connectionInfo);

                PolicyDeliverableCache.TryAdd(key, policyDeliverables);
                return policyDeliverables;
            }

            return PolicyDeliverableCache[key];
        }

        private static async Task<IReadOnlyCollection<PolicyDeliverable>> GetFromDb(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            using (PaymentManagementPolicyContext context = new PaymentManagementPolicyContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return await context.PolicyDeliverables
                    .Where(pd => pd.FundingStreamPeriod == fundingStreamPeriodCode).ToListAsync().ConfigureAwait(continueOnCapturedContext: false);
            }
        }
    }
}
