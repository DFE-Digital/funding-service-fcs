namespace ContractManagementDomain.Termination.Handlers
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using Services;
    using Extensions;
    using NServiceBus;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractTermination;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ApproveContractTerminationInitiationHandler : IHandleMessages<ApproveContractTerminationInitiationCommand>
    {
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly ITerminateContractFeedService _terminateContractFeedService;

        public ApproveContractTerminationInitiationHandler(ILogger logger,
            ISessionConnectionFactory sessionConnectionFactory,
            ITerminateContractFeedService terminateContractFeedService)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _terminateContractFeedService = terminateContractFeedService;
        }

        public async Task Handle(ApproveContractTerminationInitiationCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                ContractManagementLoggingEvents.ApproveContractTerminationInitiationCommandReceived,
                $"Contract Termination - START: ApproveContractTerminationInitiationCommand for {message} received");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            var terminateContractFeedServiceReponse = _terminateContractFeedService.UpdateContractAndAddToFeed(connectionInfo, message.GetContractIdentifier(),
                SetSubStatus, context.MessageId, AtomItemType.ContractTerminationInitiated);

            if (terminateContractFeedServiceReponse.AtomItemCreationResult.IsGoodToContinue())
            {
                ContractPlacedUnderTerminationForApproveInitiationEvent contractPlacedUnderTerminationForApproveInitiationEvent 
                    = new ContractPlacedUnderTerminationForApproveInitiationEvent
                {
                    ContractNumber = message.ContractNumber,
                    VersionNumber = message.VersionNumber,
                    SubVersionNumber = message.SubVersionNumber,
                    TerminationAllocations = GetTerminationAllocationsThatHaveATerminationDate(terminateContractFeedServiceReponse.CorporateContract)
                };

                await SendSetContractTerminationToCompleteInCrm(context,
                    message.ContractNumber,
                    message.VersionNumber,
                    message.SubVersionNumber,
                    message.ShouldInitiateAmendmentOnApproval);

                await context.Publish(contractPlacedUnderTerminationForApproveInitiationEvent).ConfigureAwait(continueOnCapturedContext: false);

                var releaseQueuedFundingAllocationsForContractsCommand =
                    new ReleaseQueuedFundingAllocationsForContractsCommand(new List<ContractIdentity>{
                        new ContractIdentity(message.ContractNumber, message.VersionNumber, message.SubVersionNumber)});

                releaseQueuedFundingAllocationsForContractsCommand.IgnoreContractIdentitiesWhenConsideringIntent = true;

                await context.Send(releaseQueuedFundingAllocationsForContractsCommand);
            }

            _logger.LogInformation(
                ContractManagementLoggingEvents.ApproveContractTerminationInitiationCommandProcessed,
                $"Contract Termination - END: ApproveContractTerminationInitiationCommand for {message} processed");
        }

        private static void SetSubStatus(Contract masterContract)
        {
            masterContract.SetChildContractsSubStatus(newStatus: "Under Termination");
        }

        private List<TerminationAllocation> GetTerminationAllocationsThatHaveATerminationDate(Contract corporateContract)
        {
            return corporateContract.contracts.SelectMany(sc => sc.contractAllocations)
                .Select(ca => new TerminationAllocation(ca.contractAllocationNumber, ca.fundingStreamPeriodCode, ca.FundingCessationDate))
                .Where(ta => ta.TerminationDate != null)
                .ToList();
        }

        private async Task SendSetContractTerminationToCompleteInCrm(
            IMessageHandlerContext context,
            string contractNumber,
            int versionNumber,
            int subVersionNumber,
            bool shouldInitiateAmendmentOnApproval)
        {
            var sendOptions = new SendOptions();
            sendOptions.RouteToThisEndpoint();

            await context.Send(new SetContractTerminationToCompleteInCrmCommand
            {
                ContractNumber = contractNumber,
                VersionNumber = versionNumber,
                SubVersionNumber = subVersionNumber,
                RequiredCrmServiceResponse = shouldInitiateAmendmentOnApproval ?
                        SetContractTerminationToCompleteInCrmCommand.CrmServiceResponse.TerminationInitiationSuccessfulIssueAmend :
                        SetContractTerminationToCompleteInCrmCommand.CrmServiceResponse.TerminationInitiationSuccessful
            },
                sendOptions)
                .ConfigureAwait(continueOnCapturedContext: false);
        }
    }
}