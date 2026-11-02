namespace OrganisationDomain.Implementation.BusinessLogic
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Reflection;
    using System.Xml.Linq;
    using Converters;
    using Extensions;
    using Integration.Entities;
    using Microsoft.WindowsAzure.Storage.Table;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class CpdsStub : ICpdsOrganisationRetriever, ICpdsSummaryRetriever
    {
        private static readonly string StubTableName = $"GatewayServiceStub{ConfigurationManager.AppSettings["StorageTableSuffix"]}";
        private const string StubPartitionKey = "GatewayServiceStubPartitionKey";
        private readonly ILogger _logger;
        private readonly IAzureTableStore _azureTableStore;
        private readonly ICpdsProviderConverter _cpdsProviderConverter;

        private static readonly IDictionary<string, string> ProviderUkprnToXmlResource = new Dictionary<string, string>
        {
            { "10000000", "GetProvidersByUKPRN - NotFound.xml" },
            { "10009986", "GetProvidersByUKPRN - StatusOfActive.xml" },
            { "10009987", "GetProvidersByUKPRN - StatusOfInactive.xml" },
            { "10009988", "GetProvidersByUKPRN - StatusOfDissolved.xml" },
            { "10009989", "GetProvidersByUKPRN - StatusOfLockedStructure.xml" },
            { "78900203", "GetProvidersByUKPRN - NotFound.xml" }
        };
        private static readonly IDictionary<string, string> ProviderStatusToXmlResource = new Dictionary<string, string>
        {
            { "ACTIVE", "GetProvidersByUKPRN - StatusOfActive.xml" },
            { "DELETED", "GetProvidersByUKPRN - StatusOfDeleted.xml" },
            { "DISSOLVED", "GetProvidersByUKPRN - StatusOfDissolved.xml" },
            { "INACTIVE", "GetProvidersByUKPRN - StatusOfInactive.xml" },
            { "INLIQUIDATION", "GetProvidersByUKPRN - StatusOfInLiquidation.xml" },
            { "NOTFOUND", "GetProvidersByUKPRN - NotFound.xml" }
        };

        public CpdsStub(ILogger logger, IAzureTableStore azureTableStore, ICpdsProviderConverter cpdsProviderConverter)
        {
            _logger = logger;
            _azureTableStore = azureTableStore;
            _cpdsProviderConverter = cpdsProviderConverter;
        }

        public XDocument GetProviderByUkprn(int ukprn)
        {
            _logger.LogInformation(1, $"Getting Org from CpdsStubOrganisationRetriever ukprn:{ukprn}");

            const string defaultXmlResource = "GetProvidersByUKPRN.xml";

            string resourceFileName = ProviderUkprnToXmlResource.GetValueOrDefault(ukprn.ToString(), defaultXmlResource);

            StubEntity storedStubEntity = GetEntityFromStubStorage(ukprn);
            if (storedStubEntity != null)
            {
                resourceFileName = ProviderStatusToXmlResource.GetValueOrDefault(storedStubEntity.Status, resourceFileName);
            }

            string xmlContent = GetXmlFromFile(resourceFileName);

            xmlContent = xmlContent.Replace("{UKPRN}", ukprn.ToString())
                    .Replace("{UPIN}", new Random().Next(1, 99999).ToString());

            return XDocument.Parse(xmlContent);
        }

        public XDocument GetProviderByUkprnAndUpin(int ukprn, int upin)
        {
            return GetProviderByUkprn(ukprn);
        }

        public List<ProviderSequence> RetrieveSummary()
        {
            string xmlContent = GetXmlFromFile("GetProviderSummaryByName.xml");

            _cpdsProviderConverter.CpdsXml = xmlContent;
            return _cpdsProviderConverter.ConvertXmlToProviders();
        }

        private static string GetXmlFromFile(string fileName)
        {
            const string pkgNamespace = "OrganisationDomain.Implementation.Resources";

            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{pkgNamespace}.{fileName}"))
            {
                using (StreamReader reader = new StreamReader(stream))
                {
                    return reader.ReadToEnd();
                }
            }
        }

        private StubEntity GetEntityFromStubStorage(int ukprn)
        {
            return _azureTableStore.GetRow<StubEntity>(StubTableName, StubPartitionKey, ukprn.ToString());
        }

        private class StubEntity : TableEntity
        {
            public string Ukprn { get; set; }

            public string Status { get; set; }
        }
    }
}
