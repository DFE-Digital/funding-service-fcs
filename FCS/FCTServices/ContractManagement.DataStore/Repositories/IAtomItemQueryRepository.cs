namespace ContractManagement.DataStore.Repositories
{
    using Model;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;

    public interface IAtomItemQueryRepository
    {
        int PageSize { get; }

        int? GetNextPageNumber(int? requestedPage);

        int? GetPreviousPageNumber(int page);

        StoragePage<AtomFeedItem> GetEntitiesForPage(int page);

        StoragePage<AtomFeedItem> GetEntitiesForLatestPage();

        AtomFeedItem GetItemById(int id);

        bool Any();
    }
}
