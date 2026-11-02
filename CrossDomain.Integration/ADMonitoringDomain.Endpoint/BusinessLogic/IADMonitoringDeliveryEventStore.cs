using ADMonitoringDomain.DataStore.Model;
using System;

namespace ADMonitoringDomain.Endpoint.BusinessLogic
{
    public interface IADMonitoringDeliveryEventStore
    {
        void StoreEvent(AllocationDeliveryEventReceived eventToStore, Type typeOfEvent);
    }
}
