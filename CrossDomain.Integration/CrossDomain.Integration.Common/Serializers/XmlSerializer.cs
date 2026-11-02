namespace SFA.FCT.CrossDomain.Integration.Common.Serializers
{
    using System.IO;
    using System.Text;

    public class XmlSerializer : ISerializer
    {
        public string Serialize<T>(T source)
        {
            var result = string.Empty;
            if (source != null)
            {
                var s = new System.Xml.Serialization.XmlSerializer(source.GetType());
                var sb = new StringBuilder();
                using (var writer = new StringWriter(sb))
                {
                    s.Serialize(writer, source);
                }
                result = sb.ToString();
            }
            return result;
        }

        public T Deserialize<T>(string source)
        {
            var result = default(T);
            if (string.IsNullOrWhiteSpace(source))
            {
                var s = new System.Xml.Serialization.XmlSerializer(source.GetType());
                var sr = new StringReader(source);
                result = (T)s.Deserialize(sr);
            }
            return result;
        }
    }
}
