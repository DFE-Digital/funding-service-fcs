namespace OrganisationDomain.Implementation.BusinessLogic
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Xml.Linq;
    using Mappers;
    using BusinessExceptions;
    using schemas.sfa.gov.uk.cpds.gatewayservice;
    using SFA.FCT.CrossDomain.Integration.Entities.Organisation;
    using SFA.FCT.Framework.Logging.Interfaces;
    using OrganisationDomain.Common;

    public class CpdsOrganisationRetriever : ICpdsOrganisationRetriever
    {
        private readonly ILogger _logger;
        private readonly GatewayServiceContract _gatewayServiceContract;
        private readonly ICpdsMapper _cpdsMapper;
        private readonly ICpdsXmlValidator _cpdsXmlValidator;

        public CpdsOrganisationRetriever(ILogger logger, GatewayServiceContract gatewayServiceContract, ICpdsMapper cpdsMapper, ICpdsXmlValidator cpdsXmlValidator)
        {
            _logger = logger;
            _gatewayServiceContract = gatewayServiceContract;
            _cpdsMapper = cpdsMapper;
            _cpdsXmlValidator = cpdsXmlValidator;
        }

        public XDocument GetProviderByUkprn(int ukprn)
        {
            var organisationXml = RetrieveOrganisationFromCpds(ukprn);
            if (organisationXml == null)
            {
                return null;
            }

            _cpdsXmlValidator.RemoveProvidersThatAreNotActiveOrDoNotHaveANumericUpin(organisationXml);

            // If there are still duplicates, then we can't identify a unique record so return an error
            if (_cpdsXmlValidator.HasMultipleActiveProvidersWithTheSameUkprn(organisationXml))
            {
                throw new DuplicateUkprnProviderException(string.Format("Multiple records with the same UKPRN of {0} found. Unable to resolve.", ukprn));
            }

            XNamespace ns = "http://xpims.lsc.gov.uk/ProviderDataSetV2";

            if (organisationXml.Root.Elements(ns + "Provider").FirstOrDefault() != null)
            {
                var orgAsDbEntity = _cpdsMapper.MapProviderXmlToDbEntity(organisationXml);
                var orgAsCorporateSchema = _cpdsMapper.MapDbEntityToCorpSchema(orgAsDbEntity);

                List<OrganisationSchemaValidationError> validationErrors = new List<OrganisationSchemaValidationError>();

                if (!_cpdsXmlValidator.IsOrganisationValidAgainstOrganisationCorporateSchema(orgAsCorporateSchema, out validationErrors))
                {
                    StringBuilder errorMessage = new StringBuilder();
                    validationErrors.ForEach(
                        x => errorMessage.AppendFormat("Line number: {0}, Line position: {1}, Error message: {2}", x.LineNumber, x.LinePosition, x.ErrorMessage));
                    throw new OrganisationCorporateSchemaValidationFailedException(errorMessage.ToString());
                }
            }

            return organisationXml;
        }

        // This is called by the Organisation Update process. CPDS can potentially return multiple providers with the same UKPRN.
        // We then need to filter these using the UPIN.
        public XDocument GetProviderByUkprnAndUpin(int ukprn, int upin)
        {
            var organisationXml = RetrieveOrganisationFromCpds(ukprn);
            _cpdsXmlValidator.RemoveProvidersThatDoNotHaveAMatchingUpin(organisationXml, upin);
            return organisationXml;
        }

        private XDocument RetrieveOrganisationFromCpds(int ukprn)
        {
            var request = new GProvByUKPRINRequest
            {
                UKPRNs = new UKPRNCollection { new UKPRN { UKPRNData = ukprn.ToString() } }
            };

            GProvByUKPRNResponse response;

            try
            {
                response = _gatewayServiceContract.GetProvidersByUKPRN(request);
                
                if ((response == null) || (response.RawCPDSResponse == null))
                {
                    _logger.LogInformation(OrganisationDomainEventLoggingId.CpdsOrgRetrieverRawCPDS, "CPDS returned nothing!");
                    return null;
                }
                else
                {
                    _logger.LogInformation(OrganisationDomainEventLoggingId.CpdsOrgRetrieverRawCPDS, "Raw CPDS response {0} ", response.RawCPDSResponse);
                }
            }
            catch (Exception e)
            {
                _logger.LogError(OrganisationDomainEventLoggingId.CpdsOrgRetrieverError, "Contact with CPDS has failed. Error occurred trying to call GetProvidersByUKPRN: {0}.", e.ToString());
                throw;
            }

            _logger.LogInformation(OrganisationDomainEventLoggingId.GetOrganisationHandlerMessageReceived, $" response.RawCPDSResponse {ukprn} - {response.RawCPDSResponse}");
            var organisationXml = XDocument.Parse(response.RawCPDSResponse);
            return organisationXml;
        }
    }
}