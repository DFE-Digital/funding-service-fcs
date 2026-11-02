namespace AllocationDeliveryService.Tests.Extensions
{
    using System.Text;
    using Serialization = System.Xml.Serialization;
    using System.IO;

    public static class SerializationExtensions
    {
        public static string SerializeToXml<T>(this T objectToSerialize) where T : class
        {
            if (objectToSerialize == null)
                return null;

            using (var stream = new MemoryStream())
            {
                var serializer = new Serialization.XmlSerializer(typeof(T));
                serializer.Serialize(stream, objectToSerialize);
                return new UTF8Encoding().GetString((stream).ToArray());
            }
        }
    }
}
