namespace FctServices.ServiceImplementation.GatewayService
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.ServiceModel;
    using System.Threading.Tasks;
    using System.Web.Services.Protocols;
    using MessageContract.GatewayService;
    using ServiceContract.GatewayService;
    using Storage;

    [ServiceBehavior(Namespace = "http://schemas.sfa.gov.uk/cpds.gatewayservice")]
    public class GatewayService : GatewayServiceContract
    {
        private const string ResourceNamespace = "FctServices.ServiceImplementation.GatewayService.Resources";
        private const string DefaultXmlResource = "GetProvidersByUKPRN.xml";
        private static readonly IDictionary<string, string> ProviderUkprnToXmlResource = new Dictionary<string, string>
        {
            { "10000000", "GetProvidersByUKPRN - NotFound.xml" },
            { "10009986", "GetProvidersByUKPRN - StatusOfActive.xml" },
            { "10009987", "GetProvidersByUKPRN - StatusOfInactive.xml" },
            { "10009988", "GetProvidersByUKPRN - StatusOfDissolved.xml" },
            { "10009989", "GetProvidersByUKPRN - StatusOfLockedStructure.xml" },
            { "78900201", "GetProvidersByUKPRN - ADEProvider.xml" },
            { "78900203", "GetProvidersByUKPRN - NotFound.xml" },
            { "78900299", "GetProvidersByUKPRN - MultipleProviders.xml" },
            { "88999994", "GetProvidersByUKPRN - StatusOfInLiquidation.xml" },
            { "88999995", "GetProvidersByUKPRN - StatusOfDeleted.xml" },
            { "99990001", "GetProvidersByUKPRN - 99990001.xml" },
            { "99990002", "GetProvidersByUKPRN - 99990002.xml" },
            { "99990003", "GetProvidersByUKPRN - 99990003.xml" },
            { "99990004", "GetProvidersByUKPRN - 99990004.xml" },
            { "99990005", "GetProvidersByUKPRN - 99990005.xml" },
            { "98126578", "GetProvidersByUKPRN - StatusOfInactive.xml" },
            { "99990087", "GetProvidersByUKPRN - InvalidXml.xml" }
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

        private readonly GatewayServiceStubRepository _stubRepository;

        public GatewayService()
        {
            _stubRepository = new GatewayServiceStubRepository(new AzureTableStore());
        }

        GProvByUKPRNResponse GatewayServiceContract.GetProvidersByUKPRN(GProvByUKPRINRequest request)
        {
            GProvByUKPRNResponse response = new GProvByUKPRNResponse
            {
                RawCPDSResponse = null
            };

            if (request.UKPRNs.Count > 0)
            {
                string ukprn = request.UKPRNs.First().UKPRNData;

                switch (ukprn)
                {
                    case "20000000":
                        throw new SoapException("As requested SOAP fault raised", null);

                    case "98126578":
                        Task.Delay(30000).Wait(); // mimic timeout in org service
                        break;
                }

                string xmlContent = GetResourceXmlForUkprn(ukprn);

                response.RawCPDSResponse =
                    xmlContent
                    .Replace("{UKPRN}", ukprn)
                    .Replace("{UPIN}", new Random().Next(1, 99999).ToString());
            }

            return response;
        }

        private string GetResourceXmlForUkprn(string ukprn)
        {
            string xmlResourceFileName = GetXmlResourceFileName(ukprn);
            string xmlResourceFullPath = $"{ResourceNamespace}.{xmlResourceFileName}";

            using (Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(xmlResourceFullPath))
            using (StreamReader reader = new StreamReader(stream))
            {
                return reader.ReadToEnd();
            }
        }

        private string GetXmlResourceFileName(string ukprn)
        {
            string xmlResourceFileName = ProviderUkprnToXmlResource.ContainsKey(ukprn) ? ProviderUkprnToXmlResource[ukprn] : DefaultXmlResource;

            GatewayServiceStubEntity storedStubEntity = _stubRepository.FindByUkprn(ukprn);
            if (storedStubEntity != null && ProviderStatusToXmlResource.ContainsKey(storedStubEntity.Status))
            {
                xmlResourceFileName = ProviderStatusToXmlResource[storedStubEntity.Status];
            }

            return xmlResourceFileName;
        }

        GProvByNameResponse GatewayServiceContract.GetProviderSummaryByName(GProvByNameRequest request)
        {
            string xmlResourceFullPath = $"{ResourceNamespace}.GetProviderSummaryByName.xml";

            using (Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(xmlResourceFullPath))
            using (StreamReader reader = new StreamReader(stream))
            {
                return new GProvByNameResponse
                {
                    RawCPDSResponse = reader.ReadToEnd()
                };
            }
        }

        GProvByUPINResponse GatewayServiceContract.GetProvidersByUpin(GProvByUPINRequest request)
        {
            return new GProvByUPINResponse
            {
                RawCPDSResponse = null
            };
        }
    }
}
