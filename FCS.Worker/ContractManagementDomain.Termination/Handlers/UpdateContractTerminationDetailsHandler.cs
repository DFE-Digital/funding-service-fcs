namespace ContractManagementDomain.Termination.Handlers
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using Extensions;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractTermination;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class UpdateContractTerminationDetailsHandler : IHandleMessages<UpdateContractTerminationDetailsCommand>
    {
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly ITerminateContractFeedService _terminateContractFeedService;

        public UpdateContractTerminationDetailsHandler(ILogger logger, 
            ISessionConnectionFactory sessionConnectionFactory,
            ITerminateContractFeedService terminateContractFeedService)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _terminateContractFeedService = terminateContractFeedService;
        }

        public async Task Handle(UpdateContractTerminationDetailsCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                ContractManagementLoggingEvents.UpdateContractTerminationDetailsCommandReceived,
                $"Update Termination Details - START: UpdateContractTerminationDetailsCommand for {message} received");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            var terminateContractFeedServiceResponse = _terminateContractFeedService.UpdateContractAndAddToFeed(connectionInfo, message.GetContractIdentifier(),
                SetSubStatus, context.MessageId, AtomItemType.ContractTerminationDetailsUpdated);

            if (terminateContractFeedServiceResponse.AtomItemCreationResult.IsGoodToContinue())
            {
                ContractPlacedUnderTerminationForUpdatedDetailsEvent contractPlacedUnderTerminationForUpdatedDetailsEvent
                    = new ContractPlacedUnderTerminationForUpdatedDetailsEvent
                    {
                        ContractNumber = message.ContractNumber,
                        VersionNumber = message.VersionNumber,
                        SubVersionNumber = message.SubVersionNumber,
                        TerminationAllocations = GetTerminationAllocationsThatHaveATerminationDate(terminateContractFeedServiceResponse.CorporateContract)
                    };

                await SendSetContractTerminationToCompleteInCrm(context,
                    message.ContractNumber,
                    message.VersionNumber,
                    message.SubVersionNumber);

                await context.Publish(contractPlacedUnderTerminationForUpdatedDetailsEvent).ConfigureAwait(continueOnCapturedContext: false);
            }

            _logger.LogInformation(
                ContractManagementLoggingEvents.UpdateContractTerminationDetailsCommandProcessed,
                $"Update Termination Details - END: UpdateContractTerminationDetailsCommand for {message} processed");
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
            int subVersionNumber)
        {
            var sendOptions = new SendOptions();
            sendOptions.RouteToThisEndpoint();

            await context.Send(new SetContractTerminationToCompleteInCrmCommand
                    {
                        ContractNumber = contractNumber,
                        VersionNumber = versionNumber,
                        SubVersionNumber = subVersionNumber,
                        RequiredCrmServiceResponse = SetContractTerminationToCompleteInCrmCommand.CrmServiceResponse.TerminationDetailsUpdateSuccessful
                    },
                    sendOptions)
                .ConfigureAwait(continueOnCapturedContext: false);
        }
    }
}