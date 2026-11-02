namespace SFA.FCT.ContractManagementService.AtomFeed
{
    using System.IO;
    using System.ServiceModel.Syndication;
    using System.Xml;
    using PerformanceManagementDomain.DataStore.Models;
    using FundingClaimReconciliation.Extentions;
    using global::ContractManagementService.AtomFeed;

    public class FundingClaimReconciliationFeedSyndicationItemCreator : ISyndicationItemCreator<AtomFeedItem>  
    {
        private string _mediaType;

        public FundingClaimReconciliationFeedSyndicationItemCreator(string mediaType)
        {
            _mediaType = mediaType;
        }

        public SyndicationItem CreateItemForRow(AtomFeedItem row, string mediaType)
        {
            XmlTextReader xmlTextReader = new XmlTextReader(new StringReader(row.AtomFeedItemXml));
            SyndicationElementExtension syndicationElementExtension = new SyndicationElementExtension(xmlTextReader);
            var item = new SyndicationItem
            {
                Content = new XmlSyndicationContent(_mediaType, syndicationElementExtension),
                Id = string.Format("uuid:{0}", row.Identifier),
                PublishDate = row.CreatedDate,
                LastUpdatedTime = row.CreatedDate,
                Title = new TextSyndicationContent(row.GetSyndicationContentTitle()),
                Summary = new TextSyndicationContent($"{{UKPRN: {row.Ukprn}, Claim Type: {row.ClaimTypeName}, Allocation Group: {row.AllocationGroupName}, Period: {row.Period}}}")
            };

            item.Categories.Add(new SyndicationCategory(row.ItemType.GetCategoryTerm(), null, row.ItemType.GetCategoryLabel()));

            return item;
        }
    }
}
