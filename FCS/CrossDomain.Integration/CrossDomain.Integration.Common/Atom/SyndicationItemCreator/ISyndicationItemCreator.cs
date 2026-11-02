namespace SFA.FCT.CrossDomain.Integration.Common.Atom.SyndicationItemCreator
{
    using System.ServiceModel.Syndication;

    public interface ISyndicationItemCreator<TEntity>
    {
        SyndicationItem CreateItemForRow(TEntity row, string mediaType);
    }
}
