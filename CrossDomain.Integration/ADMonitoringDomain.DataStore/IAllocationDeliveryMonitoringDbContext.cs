using System.Data.Entity;
using ADMonitoringDomain.DataStore.Model;

namespace ADMonitoringDomain.DataStore
{
    using System;

    public interface IAllocationDeliveryMonitoringDbContext
    {
        IDbSet<AllocationDeliveryEventReceived> AllocationDeliveryEventsReceived { get; set; }
        void SetModified(AllocationDeliveryEventReceived entity, Type typeOfEvent);

        int SaveChanges();
    }
}
