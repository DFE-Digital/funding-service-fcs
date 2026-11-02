namespace OrganisationDomain.Implementation.Converters
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Runtime.Serialization.Formatters.Binary;
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
                where provider.Element(ns + "UKPRN").Value != "0" && int.TryParse(provider.Element(ns + "Upin").Value, out dummy)
                select new ProviderSequence()
                {
                    Ukprn = int.Parse(provider.Element(ns + "UKPRN").Value),
                    Upin = int.Parse(provider.Element(ns + "Upin").Value),
                    SequenceNumber = int.Parse(provider.Attribute("ProviderSequenceNumber").Value)
                };
           
            return cpdsProviders.ToList();
        }
        
        public byte[] ConvertProviderSequenceListToBlob(List<ProviderSequence> summary)
        {
            //-------write to database-------------------------
            MemoryStream memorystream = new MemoryStream();
            BinaryFormatter bf = new BinaryFormatter();
            bf.Serialize(memorystream, summary);

            byte[] blob = memorystream.ToArray();

            // here you write yourBytesToDb to database
            return blob;
        }
        
        public List<ProviderSequence> ConvertBlobToProviderSequenceList(byte[] blob)
        {
            // ----------read from database---------------------
            // here you read from database binary data into yourBytesFromDb
            MemoryStream memorystreamd = new MemoryStream(blob);
            BinaryFormatter bfd = new BinaryFormatter();
            List<ProviderSequence> deserializedsummary = bfd.Deserialize(memorystreamd) as List<ProviderSequence>;
            return deserializedsummary;
        }
    }
}
