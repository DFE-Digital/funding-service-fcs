namespace ContractManagementService.AtomFeed
{
    using System.ServiceModel.Syndication;
    
    public interface ISyndicationItemCreator<T>
    {
        SyndicationItem CreateItemForRow(T row, string mediaType);
    }
}
