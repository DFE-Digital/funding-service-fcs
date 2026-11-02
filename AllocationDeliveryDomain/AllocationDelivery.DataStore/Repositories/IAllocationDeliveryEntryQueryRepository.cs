namespace SFA.FCT.AllocationDelivery.DataStore.Repositories
{
    using Model;

    public interface IAllocationDeliveryEntryQueryRepository
    {
        int PageSize { get; }

        int? GetNextPageNumber(int? requestedPage);

        int? GetPreviousPageNumber(int page);

        StoragePage<AllocationDeliveryEntry> GetEntitiesForPage(int page);

        StoragePage<AllocationDeliveryEntry> GetEntitiesForLatestPage();

        bool Any();
    }
}