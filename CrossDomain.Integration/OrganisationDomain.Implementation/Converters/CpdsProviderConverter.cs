
namespace OrganisationDomain.Implementation.Converters
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Text.Json;
    using System.Xml.Linq;
    using Integration.Entities;

    public class CpdsProviderConverter : ICpdsProviderConverter
    {
        public string CpdsXml { get; set; }

        public List<ProviderSequence> ConvertXmlToProviders()
        {
            if (string.IsNullOrEmpty(CpdsXml))
            {
                return null;
            }

            int dummy = 0;

            var doc = XDocument.Parse(CpdsXml);
            XNamespace ns = "http://xpims.lsc.gov.uk/ProviderDataSetV2";

            var cpdsProviders =
                from provider in doc.Descendants(ns + "Provider")
                where provider.Element(ns + "UKPRN").Value != "0"
                      && int.TryParse(provider.Element(ns + "Upin").Value, out dummy)
                select new ProviderSequence()
                {
                    Ukprn = int.Parse(provider.Element(ns + "UKPRN").Value),
                    Upin = int.Parse(provider.Element(ns + "Upin").Value),
                    SequenceNumber = int.Parse(provider.Attribute("ProviderSequenceNumber").Value)
                };

            return cpdsProviders.ToList();
        }

        // ✅ JSON SERIALIZATION (replaces BinaryFormatter)
        public byte[] ConvertProviderSequenceListToBlob(List<ProviderSequence> summary)
        {
            if (summary == null)
            {
                return null;
            }

            return JsonSerializer.SerializeToUtf8Bytes(summary);
        }

        // ✅ JSON DESERIALIZATION (replaces BinaryFormatter)
        public List<ProviderSequence> ConvertBlobToProviderSequenceList(byte[] blob)
        {
            if (blob == null || blob.Length == 0)
            {
                return new List<ProviderSequence>();
            }

            return JsonSerializer.Deserialize<List<ProviderSequence>>(blob);
        }
    }
}

