namespace SFA.FCT.ContractManagementService.AtomFeed
{
    using System.ServiceModel.Syndication;
    using global::ContractManagementService.AtomFeed;

    public interface IAtomFeedGenerator<T>
    {
        SyndicationFeed GenerateFeed(PageStorageResultSet<T> pageStorageResultSet, string id, string feedTitle, string author, ISyndicationItemCreator<T> syndicationItemCreator, bool normalizePageNumber = true);
    }
}