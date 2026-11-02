namespace SFA.FCT.ContractManagementService.AtomFeed
{
    using System.Globalization;
    using System.IO;
    using System.ServiceModel.Syndication;
    using System.Xml;
    using ContractManagement.DataStore.Model;
    using CrossDomain.Integration.Entities.CorporateContract;
    using global::ContractManagementService.AtomFeed;
    using Utils;

    public abstract class AtomFeedSyndicationItemCreator : ISyndicationItemCreator<AtomFeedItem>
    {
        public virtual  string GetSummaryText(AtomFeedItem row)
        {
            /**
           * this method relies on the xml structure (very coupled)
           */
            // e.g {UKPRN: 10017501, contractNumber : SFA-501, version: 1}

            const string namespaceString = "urn:sfa:schemas:contract";
            ContractXmlSearchHelper contractXmlSearchHelper = new ContractXmlSearchHelper(row.GetAtomFeedItemXml(), namespaceString);
            string ukprn = contractXmlSearchHelper.GetElementValue("ukprn");
            string contractNumber = contractXmlSearchHelper.GetFirstContractNumber();
            string contractVersionNumber = contractXmlSearchHelper.GetFirstContractVersionNumber();
            return string.Format(CultureInfo.InvariantCulture, contract.ToStringFormat, ukprn, contractNumber, contractVersionNumber);
        }

        public abstract string GetTitle(AtomFeedItem row);

        public abstract string GetName(AtomFeedItem row);

        public abstract string GetLabel(AtomFeedItem row);

        public abstract string GetAcceptType();

        public SyndicationItem CreateItemForRow(AtomFeedItem row, string mediaType)
        {
            XmlTextReader xmlTextReader = new XmlTextReader(new StringReader(row.GetAtomFeedItemXml()));
            SyndicationElementExtension syndicationElementExtension = new SyndicationElementExtension(xmlTextReader);
            var item = new SyndicationItem
            {
                Content = new XmlSyndicationContent(GetAcceptType(), syndicationElementExtension),
                Summary = new TextSyndicationContent(GetSummaryText(row)),
                Id = $"uuid:{row.Identifier}",
                PublishDate = row.CreatedDate,
                LastUpdatedTime = row.CreatedDate,
                Title = new TextSyndicationContent(GetTitle(row)),
            };

            item.Categories.Add(new SyndicationCategory(GetName(row), null, GetLabel(row)));

            return item;
        }
    }
}