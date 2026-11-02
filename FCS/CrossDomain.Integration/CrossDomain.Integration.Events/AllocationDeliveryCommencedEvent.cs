namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.DeliveryAllocation;

    public class AllocationDeliveryCommencedEvent : IAllocationDeliveryCommencedEvent
    {
        public allocationType Allocation { get; set; }

        public override string ToString()
        {
            return
                $"Allocation Number: {Allocation?.contractAllocationNumber}, Version: {Allocation?.contractReference.contractVersionNumber}";
        }
    }
}
