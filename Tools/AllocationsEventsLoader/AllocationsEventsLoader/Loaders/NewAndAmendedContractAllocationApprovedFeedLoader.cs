namespace AllocationsEventsLoader.Loaders
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using System;

    public class NewAndAmendedContractAllocationApprovedFeedLoader : ContractAllocationApprovedFeedLoader
    {
        public NewAndAmendedContractAllocationApprovedFeedLoader(IMonitoringDeliverablesDbContext monitoringDeliverablesDbContext) : base(monitoringDeliverablesDbContext)
        {
        }

        protected override IEnumerable<allocationType> GetAllocations(string fundingStreamPeriod)
        {
            using (IMonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                using (AllocationTypeTransformer AllocationTypeTransformer = new AllocationTypeTransformer())
                {
                    // first we need get them all for new contracts, they are in a denormalized form
                    IList<AllocationDeliverablePeriod> allocationDeliverablePeriods = context.AllocationDeliverablePeriods.Where(d => d.FundingStreamPeriodCode == fundingStreamPeriod).ToList();

                    Console.WriteLine("Got Data for fundingStreamPeriod - {0} - time {1}", fundingStreamPeriod, DateTime.Now.ToLongTimeString());
                    // now take the denormalized list are normalize back up to a list of allocation types
                    IEnumerable<allocationType> transformedList = AllocationTypeTransformer.TransformToAllocationTypeList(allocationDeliverablePeriods);
                    Console.WriteLine("Transformed Data for fundingStreamPeriod - {0} - time {1}", fundingStreamPeriod, DateTime.Now.ToLongTimeString());
                    return transformedList;
                }
            }
        }
    }
}
