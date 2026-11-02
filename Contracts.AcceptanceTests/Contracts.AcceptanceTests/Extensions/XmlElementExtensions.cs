namespace SFA.FCT.Contracts.AcceptanceTests.Extensions
{
    using System.Xml;

    public static class XmlElementExtensions
    {
        public static XmlElement AddElement(this XmlElement parent, string name, string namespaceUri)
        {
            return parent.AddElement(name, namespaceUri, null);
        }

        public static XmlElement AddElement(this XmlElement parent, string name, string namespaceUri, string value)
        {
            XmlElement newElement = parent.OwnerDocument.CreateElement(name, namespaceUri);
            if (value != null)
            {
                newElement.InnerText = value;
            }
            parent.AppendChild(newElement);
            return newElement;
        }

        public static XmlElement ParentAsElement(this XmlElement current)
        {
            return current.ParentNode as XmlElement;
        }
    }
}
