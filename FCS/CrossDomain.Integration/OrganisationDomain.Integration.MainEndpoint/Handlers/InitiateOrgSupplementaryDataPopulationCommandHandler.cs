namespace OrganisationDomain.Integration.MainEndpoint.Handlers
{
    using System.Linq;
    using System.Threading.Tasks;
    using Common;
    using DataStore.Repositories;
    using Messages.Commands;
    using MoreLinq;
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class InitiateOrgSupplementaryDataPopulationCommandHandler : IHandleMessages<InitiateOrgSupplementaryDataPopulationCommand>
    {
        private readonly IOrganisationRepository _organisationRepository;
        private readonly ILogger _logger;

        public InitiateOrgSupplementaryDataPopulationCommandHandler(IOrganisationRepository organisationRepository, ILogger logger)
        {
            _organisationRepository = organisationRepository;
            _logger = logger;
        }

        public async Task Handle(InitiateOrgSupplementaryDataPopulationCommand message, IMessageHandlerContext context)
        {
            const int batchSize = 10;
            _logger.LogInformation(OrganisationDomainEventLoggingId.InitiateOrgSupplementaryDataPopulationStart,
                "Started initiation of Organisation supplementary data population");

            var sendTasks = _organisationRepository.GetUkprnsForOrgsWithNoUkrlpData()
                .Batch(batchSize)
                .Select(b => new PopulateSupplementaryDataForUkprnBatchCommand
                {
                    UkprnBatch = b.ToList(),
                    ShouldIssueCrmNotifications = message.ShouldIssueCrmNotifications
                })
                .Select(context.Send);

            await Task.WhenAll(sendTasks);

            _logger.LogInformation(OrganisationDomainEventLoggingId.InitiateOrgSupplementaryDataPopulationComplete,
                "Completed initiation of Organisation supplementary data population");
        }
    }
}