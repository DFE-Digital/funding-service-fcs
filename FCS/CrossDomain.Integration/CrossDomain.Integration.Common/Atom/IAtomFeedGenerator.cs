namespace SFA.FCT.CrossDomain.Integration.Common.Atom
{
    using System.ServiceModel.Syndication;
    using SyndicationItemCreator;

    public interface IAtomFeedGenerator<T>
    {
        SyndicationFeed GenerateFeed(PageStorageResultSet<T> pageStorageResultSet, string id, string feedTitle, string author, ISyndicationItemCreator<T> syndicationItemCreator, bool normalizePageNumber = true);
    }
}
