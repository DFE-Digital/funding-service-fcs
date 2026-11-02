namespace ContractManagementDomain.Endpoint.ContractApproved
{
    using System;
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class PublishApprovedContractHandler : IHandleMessages<PublishApprovedContractCommand>
    {
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IContractsManager _contractsManager;
        private readonly IApprovedContractAtomFeedItemCreationService _atomFeedItemCreationService;
        private readonly IApprovedContractPopulateCacheService _approvedContractPopulateCacheService;

        public PublishApprovedContractHandler(
            ILogger logger,
            ISessionConnectionFactory sessionConnectionFactory,
            IContractsManager contractsManager,
            IApprovedContractAtomFeedItemCreationService atomFeedItemCreationService,
            IApprovedContractPopulateCacheService approvedContractPopulateCacheService)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _contractsManager = contractsManager;
            _atomFeedItemCreationService = atomFeedItemCreationService;
            _approvedContractPopulateCacheService = approvedContractPopulateCacheService;
        }

        public async Task Handle(PublishApprovedContractCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.PublishApprovedContractCommandReceived,
                $"PublishApprovedContractCommand received for {message}, Message Id: {context.MessageId}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            contract approvedContract = _contractsManager.GetCorporateContract(message.ContractNumber, message.MasterContractNumber);

            Guid messageId = new Guid(context.MessageId);

            AtomItemCreationResult atomItemCreationResult =
                await _atomFeedItemCreationService.AddApprovedContract(approvedContract, messageId, connectionInfo)
                    .ConfigureAwait(false);

            if (ShouldPublish(atomItemCreationResult))
            {
                await context.Publish(new ContractApprovedEvent
                {
                    CorporateContract = approvedContract
                }).ConfigureAwait(false);

                _logger.LogInformation(ContractManagementLoggingEvents.PublishedContractApprovedEvent, $"ContractApprovedEvent published for {message}");
            }

            if (atomItemCreationResult == AtomItemCreationResult.Added)
            {
                await _approvedContractPopulateCacheService.UpdateApprovedContractCache(approvedContract, message.MasterContractNumber, connectionInfo)
                    .ConfigureAwait(false);
            }

            _logger.LogInformation(ContractManagementLoggingEvents.PublishApprovedContractCommandProcessed,
                $"PublishApprovedContractCommand processed for {message}, Message Id: {context.MessageId}");
        }

        private static bool ShouldPublish(AtomItemCreationResult atomItemCreationResult)
        {
            return atomItemCreationResult == AtomItemCreationResult.Added || atomItemCreationResult == AtomItemCreationResult.AlreadyPresentWithSameFeedItemId;
        }
    }
}
