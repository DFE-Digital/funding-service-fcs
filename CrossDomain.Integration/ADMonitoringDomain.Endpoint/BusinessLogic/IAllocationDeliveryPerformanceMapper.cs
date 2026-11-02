namespace ADMonitoringDomain.Endpoint.BusinessLogic
{
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;

    public interface IAllocationDeliveryPerformanceMapper
    {
        AllocationDeliveryPerformance Map(AllocationDeliveryCommencedEvent adCommencedEvent, ConnectionInfo connectionInfo);
       
        AllocationDeliveryPerformance Map(AllocationDeliveryCommencedEvent adCommencedEvent, PaymentScheduleEvent paymentScheduleEvent, PaymentAggregatedEvent paymentAggregatedEvent,
            ConnectionInfo connectionInfo);
    }
}
