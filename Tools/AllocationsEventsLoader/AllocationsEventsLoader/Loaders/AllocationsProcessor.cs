namespace AllocationsEventsLoader.Loaders
{
    using System.Collections.Generic;
    using Helpers;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using System;
    using System.Configuration;
    using System.Data.Entity;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;

    public class AllocationsProcessor
    {
        private readonly IList<Allocation> _allocations;
        private LookupManager _lookupManager;
        private int _cursor = 1;

        public AllocationsProcessor(IList<Allocation> allocations)
        {
            _allocations = allocations;
        }

        public void Process()
        {
            CreateLookupManager();
            foreach (var allocation in _allocations)
            {
                Console.WriteLine("Processing item {0} of {1}", _cursor++, _allocations.Count);
                var allocationWithDates = GetStartAndEndDates(allocation);

                Console.WriteLine("Updating Allocation table for Allocation: {0}, Version: {1}.",
                    allocation.AllocationNumber, allocation.VersionNumber);
                UpdateAllocation(allocationWithDates);
            }
        }

        private Allocation GetStartAndEndDates(Allocation allocation)
        {
            var allocationData = _lookupManager.GetAllocationDateValues(allocation.AllocationNumber,
                allocation.VersionNumber);
            allocation.AllocationStartDate = allocationData.StartDate;
            allocation.AllocationEndDate = allocationData.EndDate;
            return allocation;
        }

        private void UpdateAllocation(Allocation allocation)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                var allocationToUpdate = context.Allocations.Find(
                allocation.AllocationNumber,
                     allocation.VersionNumber);
                if (allocationToUpdate != null)
                {
                    allocationToUpdate.AllocationStartDate = allocation.AllocationStartDate;
                    allocationToUpdate.AllocationEndDate = allocation.AllocationEndDate;
                    context.SaveChanges();
                    Console.WriteLine("Updated");
                }
                else
                {
                    Console.WriteLine("No record found in Allocation table for Allocation: {0}, Version: {1}...moving on.",
                        allocation.AllocationNumber, allocation.VersionNumber);
                }
            }
        }

        private void CreateLookupManager()
        {
            _lookupManager = new LookupManager
            {
                EnduringCacheManager = new EnduringCacheManager(),
                BatchCacheManager = new BatchCacheManager()
            };
            CrmConnection xrmConnection =
               CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);
            _lookupManager.OrganizationService = new OrganizationService(xrmConnection);
        }
    }
}
