namespace ContractManagementDomain.Termination.Handlers
{
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using Extensions;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class UpdateContractModificationHandler : IHandleMessages<UpdateContractModificationCommand>
    {
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly ITerminateContractFeedService _terminateContractFeedService;

        public UpdateContractModificationHandler(ILogger logger, ISessionConnectionFactory sessionConnectionFactory, ITerminateContractFeedService terminateContractFeedService)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _terminateContractFeedService = terminateContractFeedService;
        }

        public async Task Handle(UpdateContractModificationCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                ContractManagementLoggingEvents.UpdateContractModificationCommandReceived,
                $"Termination ModificationDetailsUpdated - START: UpdateContractModificationCommand for {message} received");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            var terminateContractFeedServiceResponse = _terminateContractFeedService.UpdateContractAndAddToFeed(connectionInfo, message.GetContractIdentifier(),
                SetSubStatus, context.MessageId, AtomItemType.TerminationModificationDetailsUpdated);

            if (terminateContractFeedServiceResponse.AtomItemCreationResult.IsGoodToContinue())
            {
                var updateCrmCommand = new SetContractTerminationToCompleteInCrmCommand
                {
                    ContractNumber = message.ContractNumber,
                    VersionNumber = message.VersionNumber,
                    SubVersionNumber = message.SubVersionNumber,
                    RequiredCrmServiceResponse = SetContractTerminationToCompleteInCrmCommand.CrmServiceResponse.ModificationDetailsUpdateSuccessful
                };

                var sendOptions = new SendOptions();
                sendOptions.RouteToThisEndpoint();

                await context.Send(updateCrmCommand, sendOptions).ConfigureAwait(continueOnCapturedContext: false);
            }

            _logger.LogInformation(
                ContractManagementLoggingEvents.UpdateContractModificationCommandProcessed,
                $"Termination ModificationDetailsUpdated - END: UpdateContractModificationCommand for {message} processed");
        }

        private static void SetSubStatus(contract corporateContract)
        {
            corporateContract.SetChildContractsSubStatus(newStatus: "Modified");
        }
    }
}
