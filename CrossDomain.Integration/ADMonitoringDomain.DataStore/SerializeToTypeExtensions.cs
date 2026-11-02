using System;
using System.IO;
using System.Text;
using System.Xml.Serialization;

namespace ADMonitoringDomain.DataStore
{
    public static class SerializeToTypeExtensions
    {
        public static void Deserialize<T>(this ISerializeToType input)
        {
            if (!string.IsNullOrWhiteSpace(input.SerializedXml))
            {
                using (var stream = new MemoryStream(new UTF8Encoding().GetBytes(input.SerializedXml)))
                {
                    var serializer = new XmlSerializer(typeof(T));
                    input.Object = (T)serializer.Deserialize(stream);
                }
            }
            else
            {
                input.Object = null;
            }
        }

        public static void Deserialize(this ISerializeToType input)
        {
            if (string.IsNullOrWhiteSpace(input.SerializedXml))
            {
                input.Object = null;
                return;
            }
            using (var reader = new StringReader(input.SerializedXml))
            {
                if (input.ObjectType == null) return;

                var type = Type.GetType(input.ObjectType);

                if (type == null) return;

                var serializer = new XmlSerializer(type);
                input.Object = serializer.Deserialize(reader);
            }
        }

        public static void Serialize<T>(this ISerializeToType input)
        {
            if (input.Object == null || input.ObjectType == null)
            {
                input.Object = null;
                return;
            }

            using (var stream = new StringWriter())
            {
                var serializer = new XmlSerializer(typeof(T));
                serializer.Serialize(stream, input.Object);

                input.SerializedXml = stream.ToString();
            }
        }

        public static void Serialize(this ISerializeToType input)
        {
            if (input.Object == null || input.ObjectType == null)
            {
                input.Object = null;
                return;
            }

            using (var stream = new MemoryStream())
            {
                var type = Type.GetType(input.ObjectType);
                if (type != null)
                {
                    var serializer = new XmlSerializer(type);
                    serializer.Serialize(stream, input.Object);
                    input.SerializedXml = new UTF8Encoding().GetString((stream).ToArray());
                }
                else
                {
                    throw new ArgumentException(string.Format("The ObjectType specifide {0} is not correct", input.Object));
                }
            }
        }
    }
}
