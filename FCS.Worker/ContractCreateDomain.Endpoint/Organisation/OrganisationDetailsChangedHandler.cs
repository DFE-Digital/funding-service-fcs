namespace ContractCreateDomain.Endpoint.Organisation
{
    using System.Linq;
    using System.Threading.Tasks;
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Exceptions;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class OrganisationDetailsChangedHandler : IHandleMessages<OrganisationDetailsChanged>
    {
        private readonly ILogger _logger;
        private readonly IXrmOrganisationManager _organisationManager;

        public OrganisationDetailsChangedHandler(ILogger logger, IXrmOrganisationManager organisationManager)
        {
            _logger = logger;
            _organisationManager = organisationManager;
        }

        public Task Handle(OrganisationDetailsChanged message, IMessageHandlerContext context)
        {

            string ukprn = message.ChangedOrganisation.organisationIdentifiers.FirstOrDefault(
                oi => oi.organisationIdentifierType == organisationIdentifierType.UKPROVIDERREFERENCENUMBER)?.organisationIdentifier;

            _logger.LogInformation(message.GetType() + $" message received. ukprn - {ukprn}");

            try
            {
                _organisationManager.UpdateOrganisation(message.ChangedOrganisation);
            }
            catch (OrganisationDoesntExistException ex)
            {
                _logger.LogWarning(ex.Message);

                // No need to rethrow as this is a valid business situation. Handler should be satisfied message has been dealt with.
            }

            return Task.CompletedTask;
        }
    }
}
