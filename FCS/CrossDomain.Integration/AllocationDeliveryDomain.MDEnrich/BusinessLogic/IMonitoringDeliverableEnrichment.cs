namespace SFA.FCT.AllocationDeliveryDomain.MDEnrich.BusinessLogic
{
    using CrossDomain.Integration.Entities.DeliveryAllocation;

    public interface IMonitoringDeliverableEnrichment
    {
        void Enrich(allocationType allocation);
    }
}
