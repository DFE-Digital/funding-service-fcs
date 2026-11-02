namespace SFA.FCT.Contracts.AcceptanceTests.Pages.DTO
{
    using System.Collections.Generic;
    using AllocationDelivery.DataStore.Model;

    public class FeedAllocation
    {
        public string AllocationNumber { get; set; }

        public int AllocationVersion { get; set; }
        
        public AllocationDeliveryEntryCategory EntryCategory { get; set; }

        public List<FeedAllocationDeliverablePeriod> AllocationDeliverablePeriods { get; set; }
    }
}
