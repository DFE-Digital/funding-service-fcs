namespace SFA.FCT.Operations.Integrity.Repositories
{
    using System.Collections.Generic;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;

    public interface IAllocationDeliverablePeriodRepository
    {
        IReadOnlyCollection<AllocationDeliverablePeriod> GetActiveAllocationDeliverablePeriods(
            string organisationId,
            string fundingStreamPeriodCode,
            string uopCode);
    }
}