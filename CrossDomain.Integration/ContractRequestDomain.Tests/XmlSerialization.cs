namespace ContractRequestDomain.Tests
{
    using System;
    using System.Xml.Linq;
    using System.Xml.Serialization;

    public static class XmlSerialization
    {
        /// <summary>
        /// Deserialised objects into the specified type.
        /// </summary>
        /// <param name="xmlElement"></param>
        /// <param name="t"></param>
        /// <returns></returns>
        public static object DeserializeXml(XElement xmlElement, Type t)
        {
            try
            {
                XmlSerializer serialzer = new XmlSerializer(t);
                return serialzer.Deserialize(xmlElement.CreateReader());
            }
            catch (Exception)
            {
                throw new FormatException("Xml does not Deserialize");
            }
        }
    }
}
