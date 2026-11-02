namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories
{
    using System.Linq;
    using CrossDomain.Integration.Entities.Data;
    using Model;

    public class PublishedPayableFcrAllocationRepository: IPublishedPayableFcrAllocationRepository
    {
        public bool IsPayableFcrPublishedForAllocation(string allocationNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                return context.PublishedPayableFcrAllocations.Any(a => a.AllocationNumber == allocationNumber);
            }
        }

        public void Add(string allocationNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentSchedulePolicyContext(connectionInfo))
            {
                if (!context.PublishedPayableFcrAllocations.Any(a => a.AllocationNumber == allocationNumber))
                {
                    context.PublishedPayableFcrAllocations.Add(new PublishedPayableFcrAllocation(allocationNumber));
                }

                context.SaveChanges();
            }
        }
    }
}