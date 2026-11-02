namespace Operations.DataStore.Repositories
{
    using System.Data.Entity;
    using System.Threading.Tasks;

    public static class DuplicateContractRepository
    {
        public static async Task<int> AreThereDuplicateContractsInCrm()
        {
            using (var context = new OperationsDbContext())
            {
                return await context.DuplicateContracts.CountAsync();
            }
        }
    }
}
