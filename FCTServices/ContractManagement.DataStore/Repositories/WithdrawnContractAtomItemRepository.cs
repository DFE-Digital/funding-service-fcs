namespace ContractManagement.DataStore.Repositories
{
    using Model;

    public class WithdrawnContractAtomItemRepository : AtomItemRepository, IWithdrawnContractAtomItemRepository
    {
        public WithdrawnContractAtomItemRepository(IContractManagementDbContext contractManagementDbContext)
            : base(contractManagementDbContext)
        {
        }

        protected override AtomItemType[] AtomItemTypes => new[] {Model.AtomItemType.WithdrawnContract};
    }
}
