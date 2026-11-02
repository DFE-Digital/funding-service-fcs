using System.Configuration;

namespace SFA.FCT.FundingStreamConfigDomain.Integration
{
    public class DocumentPartConfigurationHandler : ConfigurationSection
    {
        private static readonly DocumentPartConfigurationHandler ConfigurationHandler =
            (DocumentPartConfigurationHandler)ConfigurationManager.GetSection("documentConfig/documentSectionConfigs");

        public static DocumentPartConfigurationHandler Settings { get { return ConfigurationHandler; } }

        [ConfigurationProperty("", IsDefaultCollection = true, IsKey = false, IsRequired = true)]
        public DocumentSectionConfigCollection DocumentSectionConfigs
        {
            get
            {
                return base[""] as DocumentSectionConfigCollection;
            }
        }
    }

    [ConfigurationCollection(typeof(DocumentSectionConfig), AddItemName = "documentSectionConfig", CollectionType = ConfigurationElementCollectionType.BasicMap)]
    public class DocumentSectionConfigCollection : ConfigurationElementCollection
    {
        protected override ConfigurationElement CreateNewElement()
        {
            return new DocumentSectionConfig();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return (element as DocumentSectionConfig).Name;
        }

        public DocumentSectionConfig this[int index]
        {
            get
            {
                return (DocumentSectionConfig)BaseGet(index);
            }
        }
    }

    public class DocumentSectionConfig : ConfigurationElement
    {
        [ConfigurationProperty("name", IsKey = true, IsRequired = true)]
        public string Name
        {
            get
            {
                return (string)base["name"];
            }
        }

        [ConfigurationProperty("xsltEndpoint", IsRequired = false)]
        public string XsltEndPoint
        {
            get
            {
                return (string)base["xsltEndpoint"];
            }
        }

        [ConfigurationProperty("sequenceNo", IsRequired = true)]
        public int SequenceNo
        {
            get
            {
                return (int)base["sequenceNo"];
            }
        }

        [ConfigurationProperty("documentPartConfigItems")]
        public DocumentPartConfigItemCollection DocumentPartConfigItems
        {
            get
            {
                return (DocumentPartConfigItemCollection)base["documentPartConfigItems"];
            }
        }
    }

    [ConfigurationCollection(typeof(DocumentPartConfigItem), AddItemName = "documentPartConfigItem", CollectionType = ConfigurationElementCollectionType.BasicMap)]
    public class DocumentPartConfigItemCollection : ConfigurationElementCollection
    {
        protected override ConfigurationElement CreateNewElement()
        {
            return new DocumentPartConfigItem();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return (element as DocumentPartConfigItem).Name;
        }

        public DocumentPartConfigItem this[int index]
        {
            get
            {
                return (DocumentPartConfigItem)BaseGet(index);
            }
        }
    }

    public class DocumentPartConfigItem : ConfigurationElement
    {
        [ConfigurationProperty("name", IsKey = true, IsRequired = true)]
        public string Name
        {
            get
            {
                return (string)base["name"];
            }
        }

        [ConfigurationProperty("xsltEndpoint", IsRequired = true)]
        public string XsltEndPoint
        {
            get
            {
                return (string)base["xsltEndpoint"];
            }
        }

        [ConfigurationProperty("sequenceNo", IsRequired = true)]
        public int DocumentSequenceNumber
        {
            get
            {
                return (int)base["sequenceNo"];
            }
        }

        [ConfigurationProperty("documentPartRules")]
        public DocumentPartRuleCollection DocumentPartRules
        {
            get
            {
                return (DocumentPartRuleCollection)base["documentPartRules"];
            }
        }
    }

    public class DocumentPartRule : ConfigurationElement
    {
        [ConfigurationProperty("xPath", IsKey = true, IsRequired = true)]
        public string XPath
        {
            get
            {
                return (string)base["xPath"];
            }
        }

        [ConfigurationProperty("xPathValue", IsRequired = true)]
        public string XPathValue
        {
            get
            {
                return (string)base["xPathValue"];
            }
        }
    }

    [ConfigurationCollection(typeof(DocumentPartRule), AddItemName = "documentPartRule", CollectionType = ConfigurationElementCollectionType.BasicMap)]
    public class DocumentPartRuleCollection : ConfigurationElementCollection
    {
        protected override ConfigurationElement CreateNewElement()
        {
            return new DocumentPartRule();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return (element as DocumentPartRule).XPath;
        }

        public DocumentPartRule this[int index]
        {
            get
            {
                return (DocumentPartRule)BaseGet(index);
            }
        }
    }
}
