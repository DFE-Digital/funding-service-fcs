namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.DeliveryAllocation;

    public interface IAllocationDeliveryCommencedEvent
    {
       allocationType Allocation { get; set; }
    }
}
