namespace SFA.FCT.CrossDomain.Integration.Common.Atom.SyndicationItemCreator
{
    using System.IO;
    using System.ServiceModel.Syndication;
    using System.Xml;

    public class SyndicationItemCreator<TEntity, TEntryContent> : SyndicationItemCreatorBase<TEntity, TEntryContent>, ISyndicationItemCreator<TEntity>
        where TEntryContent : IEntryContent<TEntity>, new()
    {
        public SyndicationItem CreateItemForRow(TEntity row, string mediaType)
        {
            SyndicationItem item = new SyndicationItem()
            {
                Content = new XmlSyndicationContent(new XmlTextReader(new StringReader(SerializeRowToXml(row)))),
                Summary = new TextSyndicationContent(GetSummaryText(row))
            };

            item.Links.Add(CreateSyndicationLink(mediaType));
            return item;
        }

        protected string GetSummaryText(TEntity row)
        {
            return row.ToString();
        }
    }
}
