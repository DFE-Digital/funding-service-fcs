namespace ContractManagement.DataStore.Repositories
{
    using System;
    using System.Linq;
    using Model;

    public class ApprovedContractAtomItemRepository : AtomItemRepository, IApprovedContractAtomItemRepository
    {
        protected override AtomItemType[] AtomItemTypes => new[] { Model.AtomItemType.ApprovedContract };

        public ApprovedContractAtomItemRepository(IContractManagementDbContext contractManagementDbContext)
            : base(contractManagementDbContext)
        {
        }

        public Guid? GetIdentifierForBusinessKey(string businessKey, AtomItemType atomItemType)
        {
            return _context.AtomFeedItems.SingleOrDefault(afi => afi.BusinessKey == businessKey && afi.ItemType == atomItemType)?.Identifier;
        }
    }
}
