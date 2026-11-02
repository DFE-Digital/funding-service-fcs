namespace Datafix.Tests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.AllocationDelivery.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities;

    [TestClass]
    public class Allf1718AdpFeedDataFix
    {
        private readonly IMonitoringDeliverablesDbContext _monitoringDeliverablesDbContext = new MonitoringDeliverablesDbContext();
        private readonly IAllocationDeliveryDbContext _allocationDeliveryDbContext = new AllocationDeliveryDbContext();

        [TestMethod, TestCategory("DataFix_R33")]
        public void RepublishAllf1718AdpEventsForApprovedAndReplacedContracts()
        {
            const string fspCode = "ALLF1718";

            IReadOnlyCollection<AllocationDeliveryEntry> existingAtomItems = GetExistingItems(fspCode);

            IReadOnlyCollection<AllocationDeliveryEntry> newItems = existingAtomItems.Select(MapToNewItem).ToList();

            // explicitly ensure events are posted to the feed in version number order
            newItems.GroupBy(ni => ni.AllocationNumber)
                    .SelectMany(g => g.OrderBy(ni => ni.VersionNumber))
                    .ForEach(e => _allocationDeliveryDbContext.AllocationDeliveryEntries.Add(e));

            _allocationDeliveryDbContext.SaveChanges();
        }

        private AllocationDeliveryEntry MapToNewItem(AllocationDeliveryEntry existing)
        {
            // get existing adp from event
            AllocationDeliveryPerformance allocationDeliveryPerformance = existing.GetAllocationDeliveryPerformanceXml().DeserializeXml<AllocationDeliveryPerformance>();
            
            // swap deliverable codes
            allocationDeliveryPerformance.ContractDeliverables
                .Where(d => d.DeliverableCode == 3).ForEach(d => d.DeliverableCode = 6);

            allocationDeliveryPerformance.ContractDeliverables
                .Where(d => d.DeliverableCode == 4).ForEach(d => d.DeliverableCode = 7);

            // swap scheduled payment deliverable codes
            allocationDeliveryPerformance.ScheduledPaymentPeriods.ForEach(
                spp => spp.ScheduledPayment.Where(sp => sp.DeliverableCode == 3).ForEach(sp => sp.DeliverableCode = 6));

            allocationDeliveryPerformance.ScheduledPaymentPeriods.ForEach(
                spp => spp.ScheduledPayment.Where(sp => sp.DeliverableCode == 4).ForEach(sp => sp.DeliverableCode = 7));

            // remove actuals
            allocationDeliveryPerformance.ActualsPeriods = null;

            return AllocationDeliveryEntry.Create(allocationDeliveryPerformance, existing.AllocationDeliveryCategory);
        }

        private IReadOnlyCollection<AllocationDeliveryEntry> GetExistingItems(string fspCode)
        {
            List<string> allocationNumbers =
                _monitoringDeliverablesDbContext.AllocationDeliverablePeriods
                                                .Where(adp => adp.FundingStreamPeriodCode == fspCode)
                                                .Select(adp => adp.ContractAllocationNumber)
                                                .Distinct()
                                                .ToList();

            var existingItems = allocationNumbers.SelectMany(
                a => _allocationDeliveryDbContext.AllocationDeliveryEntries
                                                 .Where(entry => entry.AllocationNumber == a
                                                        && (entry.AllocationDeliveryCategory == AllocationDeliveryEntryCategory.AmendedContractAllocationApproved
                                                            || entry.AllocationDeliveryCategory == AllocationDeliveryEntryCategory.NewContractAllocationApproved)))
                                                 .ToList();
            return existingItems;
        }
    }
}