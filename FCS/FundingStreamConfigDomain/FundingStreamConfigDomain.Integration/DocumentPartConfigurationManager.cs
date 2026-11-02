using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using SFA.FCT.FundingStreamConfigDomain.Common;

namespace SFA.FCT.FundingStreamConfigDomain.Integration
{
    public class DocumentPartConfigurationManager : IDocumentPartConfigurationManager
    {
        public IList<DocumentSectionType> GetDocumentPartConfigurationItems()
        {
            var config = DocumentPartConfigurationHandler.Settings;

            if (config == null)
            {
                throw new ConfigurationErrorsException("Configuration section is invalid.");
            }

            return (from DocumentSectionConfig documentSectionConfig in config.DocumentSectionConfigs
                    let documentPartConfigurationItemList = (from DocumentPartConfigItem documentPartConfigItem in documentSectionConfig.DocumentPartConfigItems
                                                             let dictionary = (from DocumentPartRule documentPartRule in documentPartConfigItem.DocumentPartRules
                                                                               select new KeyValuePair<string, string>(documentPartRule.XPath, documentPartRule.XPathValue)).ToList()
                                                             select new DocumentPartConfigurationItem
                                                             {
                                                                 Name = documentPartConfigItem.Name,
                                                                 XsltEndPoint = documentPartConfigItem.XsltEndPoint,
                                                                 DocumentSequenceNumber = documentPartConfigItem.DocumentSequenceNumber,
                                                                 DocumentPartRule = dictionary
                                                             }).ToList()
                    select new DocumentSectionType
                    {
                        Name = documentSectionConfig.Name,
                        HeaderPageXsltEndPoint = documentSectionConfig.XsltEndPoint,
                        DocumentSequenceNumber = documentSectionConfig.SequenceNo,
                        DocumentPartConfigurationItems = documentPartConfigurationItemList
                    }).ToList();

        }
    }
}