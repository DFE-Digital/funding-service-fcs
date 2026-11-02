namespace ContractManagementDomain.Termination.Handlers
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using DTOs;
    using Extensions;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ApproveContractModificationHandler : IHandleMessages<ApproveContractModificationCommand>
    {
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly ITerminateContractFeedService _terminateContractFeedService;

        public ApproveContractModificationHandler(ILogger logger, ISessionConnectionFactory sessionConnectionFactory, ITerminateContractFeedService terminateContractFeedService)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _terminateContractFeedService = terminateContractFeedService;
        }

        public async Task Handle(ApproveContractModificationCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                ContractManagementLoggingEvents.ApproveContractModificationCommandReceived,
                $"Contract Modification - START: ApproveContractModificationCommandReceived received for {message}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            UpdateSubStatusAndAddContractToFeedResult result = _terminateContractFeedService.UpdateContractAndAddToFeed(
                    connectionInfo, message.GetContractIdentifier(), SetSubStatus, context.MessageId, AtomItemType.ContractModified);

            if (result.AtomItemCreationResult.IsGoodToContinue())
            {
                var updateCrmCommand = new SetContractTerminationToCompleteInCrmCommand
                {
                    ContractNumber = message.ContractNumber,
                    VersionNumber = message.VersionNumber,
                    SubVersionNumber = message.SubVersionNumber,
                    RequiredCrmServiceResponse = SetContractTerminationToCompleteInCrmCommand.CrmServiceResponse.ModificationSuccessful
                };

                var sendOptions = new SendOptions();
                sendOptions.RouteToThisEndpoint();

                await context.Send(updateCrmCommand, sendOptions)
                    .ConfigureAwait(continueOnCapturedContext: false);

                var releaseQueuedFundingAllocationsForContractsCommand =
                    new ReleaseQueuedFundingAllocationsForContractsCommand(new List<ContractIdentity>{
                        new ContractIdentity(message.ContractNumber, message.VersionNumber, message.SubVersionNumber)});

                releaseQueuedFundingAllocationsForContractsCommand.IgnoreContractIdentitiesWhenConsideringIntent = true;

                await context.Send(releaseQueuedFundingAllocationsForContractsCommand);
            }

            _logger.LogInformation(
                ContractManagementLoggingEvents.ApproveContractModificationCommandProcessed,
                $"Contract Modification - END: ApproveContractModificationCommandReceived processed for {message}");
        }

        private static void SetSubStatus(contract masterContract)
        {
            masterContract.SetChildContractsSubStatus(newStatus: "Modified");
        }
    }
}
