namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    public interface IPolicyDeliverableRepository
    {
        Task<IReadOnlyCollection<PolicyDeliverable>> GetPolicyDeliverables(string fundingStreamPeriodCode, ConnectionInfo connectionInfo);
    }
}
