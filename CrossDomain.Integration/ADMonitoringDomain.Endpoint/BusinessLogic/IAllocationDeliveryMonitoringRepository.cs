extern alias Entities;
using ADMonitoringDomain.DataStore.Model;
using SFA.FCT.AllocationDelivery.DataStore.Model;
using Entities::SFA.FCT.CrossDomain.Integration.Entities;
using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

namespace ADMonitoringDomain.Endpoint.BusinessLogic
{
    using System;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IAllocationDeliveryMonitoringRepository
    {
        PaymentMethod GetPaymentMethod(string fspCode, ConnectionInfo connectionInfo);

        int StoreEvent(AllocationDeliveryPerformance adPerformanceEvent,AllocationDeliveryEntryCategory category, ConnectionInfo connectionInfo);

        void StoreMessagePayload(AllocationDeliveryEventReceived eventToStore, ConnectionInfo connectionInfo, Type typeOfEvent);

        void ClearEvents(string categoryName, string allocationNumber, int versionNumber, ConnectionInfo connectionInfo);

        AllocationDeliveryEventReceived GetAllocationDeliveryEventReceivedEntity(string allocationNumber, int versionNumber, string categoryName, string eventName,
            ConnectionInfo connectionInfo);
    }
}
