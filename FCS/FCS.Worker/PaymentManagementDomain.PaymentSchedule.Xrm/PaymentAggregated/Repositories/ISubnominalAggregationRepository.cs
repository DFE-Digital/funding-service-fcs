namespace PaymentManagementDomain.PaymentSchedule.PaymentAggregated.Repositories
{
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using System;
    using System.Collections.Generic;

    public interface ISubnominalAggregationRepository
    {
        IReadOnlyCollection<sfa_subnominalaggregation> GetSubnominalsRelatedToAllocationId(Guid allocationId);

        IReadOnlyCollection<sfa_subnominalaggregation> GetSubnominalsRelatedToSubnominalCodesAndAggregateKeys(
            IReadOnlyCollection<string> subnominalCodes, IReadOnlyCollection<string> aggregateKeys);
    }
}
