namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories.Atom
{
    using CrossDomain.Integration.Common.PagedStorage;
    using Models;

    public interface IAtomFeedItemQueryRepository
    {
        int PageSize { get; }

        int? GetNextPageNumber(int? requestedPage);

        int? GetPreviousPageNumber(int page);

        StoragePage<AtomFeedItem> GetEntitiesForPage(int page);

        StoragePage<AtomFeedItem> GetEntitiesForLatestPage();
    }
}
