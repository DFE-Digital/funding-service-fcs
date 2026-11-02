namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;

    public static class ContractAtomFeedItemRepository
    {
        public static IReadOnlyCollection<AtomFeedItem> GetAtomFeedItemsByContractNumber(string contractNumber)
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                string businessKeyToMatch = $"{contractNumber}:";

                return context.AtomFeedItems
                    .Where(i => i.BusinessKey.StartsWith(businessKeyToMatch))
                    .ToList();
            }
        }

        public static AtomFeedItem GetLatestFeedItemByContractNumberVersionNumberAndItemType(
            string contractNumber, int versionNumber, AtomItemType atomItemType)
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                string businessKeyToMatch = $"{contractNumber}:{versionNumber}";

                return context.AtomFeedItems
                    .Where(i => i.BusinessKey.StartsWith(businessKeyToMatch)
                                && i.ItemType == atomItemType)
                    .OrderByDescending(i => i.Id)
                    .First();
            }
        }
    }
}
