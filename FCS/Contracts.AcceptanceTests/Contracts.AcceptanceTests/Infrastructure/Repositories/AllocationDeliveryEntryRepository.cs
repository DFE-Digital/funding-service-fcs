namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using AllocationDelivery.DataStore;
    using AllocationDelivery.DataStore.Model;

    public static class AllocationDeliveryEntryRepository
    {
        public static IReadOnlyCollection<AllocationDeliveryEntry> GetAllocationDeliveryEntries(AllocationDeliveryEntryCategory allocationDeliveryEntryCategory, string allocationNumber, int versionNumber)
        {
            using (var allocationDeliveryDbContext = new AllocationDeliveryDbContext())
            {
                return allocationDeliveryDbContext.AllocationDeliveryEntries
                    .Where(x =>
                        x.AllocationDeliveryCategory == allocationDeliveryEntryCategory &&
                        x.AllocationNumber == allocationNumber &&
                        x.VersionNumber == versionNumber)
                    .Include(ad => ad.AllocationDeliveryEntryData)
                    .ToList();
            }
        }

        public static bool AreThereAdpEntriesForContract(AllocationDeliveryEntryCategory allocationDeliveryEntryCategory, string contractNumber, int versionNumber, string allocationNumber)
        {
            using (var allocationDeliveryDbContext = new AllocationDeliveryDbContext())
            {
                return allocationDeliveryDbContext.AllocationDeliveryEntries
                    .Any(entry =>
                        entry.AllocationDeliveryCategory == allocationDeliveryEntryCategory &&
                        entry.ContractNumber == contractNumber &&
                        entry.VersionNumber == versionNumber &&
                        entry.AllocationNumber == allocationNumber);
            }
        }
    }
}
