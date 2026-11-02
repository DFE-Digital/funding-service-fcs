namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Services
{
    using System;
    using System.Net;
    using System.Net.Http;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Serialization;
    using CrossDomain.Integration.Entities;
    using Framework.Logging.Interfaces;
    using Polly;

    public class OrganisationService : IOrganisationService
    {
        private readonly ILogger _logger;
        private readonly IOrganisationServiceApiHttpClient _apiHttpClient;

        public OrganisationService(ILogger logger, IOrganisationServiceApiHttpClient apiHttpClient)
        {
            _logger = logger;
            _apiHttpClient = apiHttpClient;
        }
        
        public organisation GetOrganisationForUkprn(int ukprn)
        {
            const int numRetries = 3;
            const int numSecondsToWaitBetweenRetries = 2;

            organisation organisation =
                Policy.Handle<HttpRequestException>()
                .WaitAndRetry(numRetries, _ => TimeSpan.FromSeconds(numSecondsToWaitBetweenRetries))
                .Execute(() => GetOrganisationForUkprnViaHttpApi(ukprn));

            return organisation;
        }

        private organisation GetOrganisationForUkprnViaHttpApi(int ukprn)
        {
            _logger.LogInformation(ContractCreateDomainEventLoggingId.OrganisationService, $"Retrieving organisation from Organisation Service for UKPRN: {ukprn}");

            HttpResponseMessage httpResponse = _apiHttpClient.GetHttpResponseForUkprn(ukprn);

            _logger.LogInformation(ContractCreateDomainEventLoggingId.OrganisationService, $"Retrieved organisation UKPRN: {ukprn}, {httpResponse.StatusCode}");

            if (httpResponse.IsSuccessStatusCode)
            {
                
                string content = httpResponse.Content.ReadAsStringAsync().Result;
                _logger.LogInformation(ContractCreateDomainEventLoggingId.OrganisationService, $"Retrieved organisation UKPRN: {ukprn}, content {content}");
                organisation organisation = DeserializeXmlContent(content);
                _logger.LogInformation(ContractCreateDomainEventLoggingId.OrganisationService, $"Retrieved organisation UKPRN: {ukprn}, organisation {organisation.organisationId}");

                return organisation;
            }
            else if (httpResponse.StatusCode == HttpStatusCode.NotFound)
            {
                return null;
            }
            else if (httpResponse.StatusCode == HttpStatusCode.BadRequest)
            {
                string errorContent = httpResponse.Content?.ReadAsStringAsync().Result;
                string errorMessage = $"Retrieve from Organisation Service has failed for UKPRN: {ukprn} with HTTP Status Code: {httpResponse.StatusCode}, Content: {errorContent}";
                _logger.LogError(ContractCreateDomainEventLoggingId.OrganisationService, errorMessage);

                return null; // BadRequest represents multiple active providers returned from CPDS to Org Service, treat as not found
            }
            else
            {
                string errorContent = httpResponse.Content?.ReadAsStringAsync().Result;
                string errorMessage = $"Retrieve from Organisation Service has failed for UKPRN: {ukprn} with HTTP Status Code: {httpResponse.StatusCode}, Content: {errorContent}";
                _logger.LogError(ContractCreateDomainEventLoggingId.OrganisationService, errorMessage);

                throw new HttpRequestException(errorMessage);
            }
        }

        private static organisation DeserializeXmlContent(string content)
        {
            XmlSerializer serializer = new XmlSerializer(typeof(organisation));
            XNode xml = XElement.Parse(content);

            using (XmlReader reader = xml.CreateReader())
            {
                return (organisation) serializer.Deserialize(reader);
            }
        }
    }
}