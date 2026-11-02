namespace ContractCreateDomain.Endpoint.CreateProvidersIfNecessary
{
    using System.Linq;
    using System.Threading.Tasks;
    using Extensions;
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class CreateProvidersIfNecessaryHandler : IHandleMessages<CreateProvidersIfNecessaryCommand>
    {
        private readonly ILogger _logger;
        private readonly IOrganisationService _organisationService;
        private readonly IXrmOrganisationManager _xrmOrganisationManager;

        public CreateProvidersIfNecessaryHandler(ILogger logger, IOrganisationService organisationService, IXrmOrganisationManager xrmOrganisationManager)
        {
            _logger = logger;
            _organisationService = organisationService;
            _xrmOrganisationManager = xrmOrganisationManager;
        }

        public async Task Handle(CreateProvidersIfNecessaryCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractCreateDomainEventLoggingId.CreateProvidersIfNecessaryCommandReceived, $"CreateProvidersIfNecessaryCommand received {message}");

            var organisations = message.Ukprns.Distinct()
                .Select(ukprn => _organisationService.GetOrganisationForUkprn(ukprn))
                .ToList();

            var allProvidersExist = organisations.TrueForAll(org => org != null);

            if (allProvidersExist)
            {
                organisations.ForEach(org => 
                    _xrmOrganisationManager.CreateOrganisationIfNotExists(org.ToContractOrganisation()));
            }
            
            await context.Reply(new CreateProvidersIfNecessaryReply(message.FundingId, allProvidersExist, message.PassedConfigValidation, message.ReadId, message.IsPostReadProviderNotFoundCheck, message.ParkedConfigSubStatus));

            _logger.LogInformation(ContractCreateDomainEventLoggingId.CreateProvidersIfNecessaryCommandProcessed, $"CreateProvidersIfNecessaryCommand processed {message}");
        }
    }
}
