namespace ContractManagementDomain.Termination.Handlers
{
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using DTOs;
    using Extensions;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class CancelContractModificationHandler : IHandleMessages<CancelContractModificationCommand>
    {
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly ITerminateContractFeedService _terminateContractFeedService;

        public CancelContractModificationHandler(ILogger logger, ISessionConnectionFactory sessionConnectionFactory, ITerminateContractFeedService terminateContractFeedService)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _terminateContractFeedService = terminateContractFeedService;
        }

        public async Task Handle(CancelContractModificationCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                ContractManagementLoggingEvents.CancelContractModificationCommandReceived,
                $"Cancel Contract Modification - START: CancelContractModificationCommand received for {message}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            UpdateSubStatusAndAddContractToFeedResult result = _terminateContractFeedService.UpdateContractAndAddToFeed(
                    connectionInfo, message.GetContractIdentifier(), SetSubStatusAndClearModificationValues, context.MessageId, AtomItemType.ContractModificationCancelled);

            if (result.AtomItemCreationResult.IsGoodToContinue())
            {
                var updateCrmCommand = new SetContractTerminationToCompleteInCrmCommand
                {
                    ContractNumber = message.ContractNumber,
                    VersionNumber = message.VersionNumber,
                    SubVersionNumber = message.SubVersionNumber,
                    RequiredCrmServiceResponse = SetContractTerminationToCompleteInCrmCommand.CrmServiceResponse.ModificationCancellationSuccessful
                };

                var sendOptions = new SendOptions();
                sendOptions.RouteToThisEndpoint();

                await context.Send(updateCrmCommand, sendOptions)
                    .ConfigureAwait(continueOnCapturedContext: false);
            }

            _logger.LogInformation(
                ContractManagementLoggingEvents.CancelContractModificationCommandProcessed,
                $"Cancel Contract Modification - END: CancelContractModificationCommand processed for {message}");
        }

        private static void SetSubStatusAndClearModificationValues(contract masterContract)
        {
            masterContract.SetChildContractsSubStatus(newStatus: "Approved");
            masterContract.ClearAllocationModificationValues();
        }
    }
}
