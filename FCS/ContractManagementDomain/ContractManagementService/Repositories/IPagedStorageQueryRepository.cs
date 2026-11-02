namespace ContractManagementService.Repositories
{
    using System.Threading.Tasks;

    public interface IPagedStorageQueryRepository<T>
    {
        Task<StoragePage<T>> GetEntitiesForPage(int page);

        Task<StoragePage<T>> GetEntitiesForLatestPage();
    }
}
