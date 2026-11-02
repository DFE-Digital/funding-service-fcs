using System.IO;
using System.Text;
using Serialization = System.Xml.Serialization;
namespace SFA.FCT.CrossDomain.Integration.Common.Serializers
{
    public static class SerializationHelper
    {
        public static string SerializeToXml<T>(this T objectToSerialize) where T : class
        {
            if (objectToSerialize == null)
                return null;

            using (var stream = new MemoryStream())
            {
                var serializer = new Serialization.XmlSerializer(typeof(T));
                serializer.Serialize(stream, objectToSerialize);
                return  new UTF8Encoding().GetString((stream).ToArray());
            }
        }

        public static T DeserializeXml<T>(this string xml) where T : class
        {
            if (string.IsNullOrWhiteSpace(xml))
                return default(T);

            using (var stream = new MemoryStream(new UTF8Encoding().GetBytes(xml)))
            {
                return new Serialization.XmlSerializer(typeof(T)).Deserialize(stream) as T;
            }
        }
    }
}
