namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Reflection;
    using System.Runtime.Serialization;
    using System.Xml.Linq;
    using System.Xml.Serialization;
    using Newtonsoft.Json;

    public class TestResource : IDisposable
    {
        public TestResource(string nameSpace, string resourceName)
        {
            Stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}");
        }

        public Stream Stream { get; }

        public void Dispose()
        {
            Stream?.Dispose();
            GC.SuppressFinalize(this);
        }

        public static T FromJson<T>(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<T>(streamReader.ReadToEnd());
            }
        }

        public static T FromXml<T>(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            {
                XDocument document = XDocument.Load(stream);

                XmlSerializer serializer = new XmlSerializer(typeof(T));
                return (T)serializer.Deserialize(document.Root.CreateReader());
            }
        }

        public static T FromXmlUsingDataContract<T>(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            {
                DataContractSerializer serializer = new DataContractSerializer(typeof(T));
                return (T)serializer.ReadObject(stream);
            }
        }

        public static IReadOnlyCollection<string> LinesFromText(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                List<string> lines = new List<string>();

                while (!streamReader.EndOfStream)
                {
                    lines.Add(streamReader.ReadLine());
                }

                return lines;
            }
        }

        public static string AsString(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return streamReader.ReadToEnd();
            }
        }
    }
}
