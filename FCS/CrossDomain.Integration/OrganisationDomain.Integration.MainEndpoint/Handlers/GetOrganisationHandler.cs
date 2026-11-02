namespace OrganisationDomain.Integration.MainEndpoint.Handlers
{
    using System;
    using System.Threading.Tasks;
    using Common;
    using Implementation.BusinessExceptions;
    using Implementation.BusinessLogic;
    using Messages.Messages;
    using Messages.Messages.Expires;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging.NullObjects;

    public class GetOrganisationHandler : IHandleMessages<GetOrganisationRequest>
    {
        public GetOrganisationHandler(IProviderResolver resolver, ILogger logger)
        {
            _resolver = resolver;
            _logger = logger;
        }

        private readonly ILogger _logger;

        private readonly IProviderResolver _resolver;

        public async Task Handle(GetOrganisationRequest message, IMessageHandlerContext context)
        {
            _logger.LogInformation(OrganisationDomainEventLoggingId.GetOrganisationHandlerMessageReceived, "GetOrganisationRequest message received. Ukprn:{0}.", message.Ukprn);
            _logger.LogInformation(OrganisationDomainEventLoggingId.GetOrganisationHandlerMessageReceived, $"IProviderResolver:{_resolver}");
            _logger.LogInformation(OrganisationDomainEventLoggingId.GetOrganisationHandlerMessageReceived, $"Resolver.OrganisationRetriever:{_resolver.OrganisationRetriever}");
            _logger.LogInformation(OrganisationDomainEventLoggingId.GetOrganisationHandlerMessageReceived, $"Resolver.Repository:{_resolver.Repository}");

            organisation orgToReturn = null;
            var duplicatesFound = false;
            bool organisationXmlIsInvalidAgainstSchema = false;

            if (message.Ukprn.HasValue)
            {
                try
                {
                    orgToReturn = await _resolver.GetByUkprn(message.Ukprn.Value);
                }
                catch (DuplicateUkprnProviderException e)
                {
                    duplicatesFound = true;
                    _logger.LogError(OrganisationDomainEventLoggingId.GetOrganisationHandlerError,
                        "Multiple records with same UKPRN found.", e);
                }
                catch (OrganisationCorporateSchemaValidationFailedException e)
                {
                    organisationXmlIsInvalidAgainstSchema = true;
                    _logger.LogError(OrganisationDomainEventLoggingId.GetOrganisationHandlerError, e.Message);
                }
                catch (Exception e)
                {
                    _logger.LogError(OrganisationDomainEventLoggingId.GetOrganisationHandlerError, e.Message, e.StackTrace);
                }
            }
            else
            {
                orgToReturn = _resolver.GetByOrgId(message.OrganisationId);
            }

            var response = new GetOrganisationResponse
            {
                Organisation = orgToReturn,
                DuplicatesFound = duplicatesFound,
                OrganisationXmlIsInvalidAgainstSchema = organisationXmlIsInvalidAgainstSchema
            };
            
            await context.Reply(response);
        }
    }
}
