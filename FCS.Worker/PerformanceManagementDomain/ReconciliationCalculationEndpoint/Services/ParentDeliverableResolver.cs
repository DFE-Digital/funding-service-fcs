namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public class ParentDeliverableResolver : IParentDeliverableResolver
    {
        public int GetParentDeliverableWithinClaimGroup(
            int deliverableCode,
            IReadOnlyCollection<PolicyDeliverable> policyDeliverables,
            IReadOnlyCollection<FspDeliverableClaim> allClaimGroupDeliverablesForFsp)
        {
            string deliverableGroupCode = allClaimGroupDeliverablesForFsp.Single(d => d.DeliverableCode == deliverableCode).ClaimReconciliationDeliverableGroupCode;

            IReadOnlyCollection<FspDeliverableClaim> claimGroupDeliverables = allClaimGroupDeliverablesForFsp
                .Where(d => d.ClaimReconciliationDeliverableGroupCode == deliverableGroupCode)
                .ToList();

            return GetHighestAncestorWithinClaimGroupRecursively(deliverableCode);

            int GetHighestAncestorWithinClaimGroupRecursively(int childDeliverableCode)
            {
                int highestAncestorDeliverableCode = childDeliverableCode;

                PolicyDeliverable childPolicyDeliverable = policyDeliverables.Single(pd => pd.DeliverableCode == childDeliverableCode);

                if (childPolicyDeliverable.ParentDeliverableCode.HasValue)
                {
                    bool isParentDeliverablePresentInClaimGroup = claimGroupDeliverables
                        .Any(cgd => cgd.DeliverableCode == childPolicyDeliverable.ParentDeliverableCode.Value);

                    if (isParentDeliverablePresentInClaimGroup)
                    {
                        highestAncestorDeliverableCode = GetHighestAncestorWithinClaimGroupRecursively(childPolicyDeliverable.ParentDeliverableCode.Value);
                    }
                }

                return highestAncestorDeliverableCode;
            }
        }
    }
}
