using SFA.FCT.AllocationDeliveryDomain.MDEnrich.DataStore;

namespace SFA.FCT.AllocationDeliveryDomain.MDEnrich.BusinessLogic
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.DeliveryAllocation;
    using DataStore.Model;

    public interface IMonitoringDeliverableStore
    {
        IMonitoringDeliverablesDbContext Context { get; set; }
        void RemoveAllocation(allocationType allocation);

        void StoreAllocation(allocationType allocation);

        IEnumerable<AllocationDeliverablePeriod> GetAllocationDeliverablePeriods(string organisationId,
            string fundingStreamPeriodCode, string uopCode);
    }
}
