namespace SFA.FCT.CrossDomain.Integration.Common.Atom.SyndicationItemCreator
{
    using System.IO;
    using System.ServiceModel.Syndication;
    using System.Text;
    using System.Xml.Serialization;

    public class SyndicationItemCreatorBase<TEntity, TEntryContent> where TEntryContent : IEntryContent<TEntity>, new()
    {
        protected SyndicationLink CreateSyndicationLink(string mediaType)
        {
            return new SyndicationLink
            {
                RelationshipType = AtomRelationship.SelfRelationship,
                MediaType = mediaType
            };
        }

        protected string SerializeRowToXml(TEntity item) 
        {
            IEntryContent<TEntity> entryContent = new TEntryContent();
            entryContent.SetRootProperty(item);
            return SerializeObjectToXml(entryContent);
        }

        private string SerializeObjectToXml(object entryContent)
        {
            XmlSerializer xs = new XmlSerializer(entryContent.GetType());
            using (MemoryStream buffer = new MemoryStream())
            {
                xs.Serialize(buffer, entryContent);
                buffer.Position = 0;

                return Encoding.ASCII.GetString(buffer.ToArray());
            }
        }
    }
}
