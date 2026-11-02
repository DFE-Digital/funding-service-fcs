namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services
{
    using System.Collections.Generic;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public interface IParentDeliverableResolver
    {
        int GetParentDeliverableWithinClaimGroup(
            int deliverableCode,
            IReadOnlyCollection<PolicyDeliverable> policyDeliverables,
            IReadOnlyCollection<FspDeliverableClaim> allClaimGroupDeliverablesForFsp);
    }
}
