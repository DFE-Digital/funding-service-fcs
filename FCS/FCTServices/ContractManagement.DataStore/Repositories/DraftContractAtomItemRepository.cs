namespace ContractManagement.DataStore.Repositories
{
    using Model;

    public class DraftContractAtomItemRepository : AtomItemRepository, IDraftContractAtomItemRepository
    {
        protected override AtomItemType[] AtomItemTypes => new[] { Model.AtomItemType.DraftContract };

        public DraftContractAtomItemRepository(IContractManagementDbContext contractManagementDbContext)
            : base(contractManagementDbContext)
        {
        }
    }
}
