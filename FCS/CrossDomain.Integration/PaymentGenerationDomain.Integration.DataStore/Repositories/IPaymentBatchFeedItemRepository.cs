namespace PaymentGenerationDomain.Integration.DataStore.Repositories
{
    using System.Threading.Tasks;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;

    public interface IPaymentBatchFeedItemRepository
    {
        Task<int?> GetNextPageNumber(int? requestedPage, int pageSize);

        int? GetPreviousPageNumber(int page);

        Task<StoragePage<PaymentBatchFeedItem>> GetEntitiesForPage(int pageNumber, int pageSize);

        Task<StoragePage<PaymentBatchFeedItem>> GetEntitiesForLatestPage(int pageSize);

        Task<PaymentBatchFeedItem> GetItemById(int id);

        Task<bool> Any();
    }
}
