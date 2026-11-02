namespace SFA.FCT.Contracts.AcceptanceTests.Extensions
{
    using System.Text;
    using System.IO;
    using System.ServiceModel.Syndication;
    using System.Xml;
    using System.Xml.Serialization;

    public static class SyndicationItemExtensions
    {
        public static T GetContent<T>(this SyndicationItem feedItem)
        {
            XmlWriterSettings ws = new XmlWriterSettings
            {
                Indent = true,
                IndentChars = " ",
                OmitXmlDeclaration = true,
                Encoding = new UTF8Encoding()
            };

            XmlSyndicationContent content = (XmlSyndicationContent)feedItem.Content;

            MemoryStream ms = new MemoryStream();
            XmlWriter w = XmlWriter.Create(ms, ws);
            content.WriteTo(w, "Content", "");
            w.Flush();
            ms.Position = 0;
            StreamReader sr = new StreamReader(ms);
            string xmlContent = sr.ReadToEnd();
            xmlContent = StripOffOuterElement(xmlContent);

            ms = new MemoryStream();

            StreamWriter sw = new StreamWriter(ms);
            sw.WriteLine(xmlContent);
            sw.Flush();

            ms.Position = 0;

            System.Xml.Serialization.XmlSerializer xs = new XmlSerializer(typeof(T));

            return (T)xs.Deserialize(ms);
        }

        private static string StripOffOuterElement(string xmlContent)
        {
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(xmlContent);

            return doc.FirstChild.FirstChild.OuterXml;
        }
    }
}
