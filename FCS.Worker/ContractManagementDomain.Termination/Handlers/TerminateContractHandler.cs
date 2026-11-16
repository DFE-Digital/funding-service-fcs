namespace ContractManagementDomain.Termination.Handlers
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Services;
    using ContractManagementDomain.Termination.DTOs;
    using ContractManagementDomain.Termination.Extensions;
    using ContractManagementDomain.Termination.Infrastructure;
    using ContractManagementDomain.Termination.Repositories;
    using ContractManagementDomain.Termination.Services;
    using NServiceBus;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.ContractManagementService.Common.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class TerminateContractHandler : IHandleMessages<TerminateContractCommand>
    {
        private readonly ILogger _logger;
        private readonly ITerminateContractInfoCreator _terminateContractInfoCreator;
        private readonly ITerminateContractValidationService _terminateContractValidationService;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly ICrmContractRepository _crmContractRepository;
        private readonly IContractsManager _contractsManager;
        private readonly ILegalDeliverableService _legalDeliverableService;
        private readonly IApprovalOnwardsContractAtomFeedService _approvalOnwardsContractAtomFeedService;
        private readonly ICorporateContractService _corporateContractService;

        public TerminateContractHandler(
            ILogger logger,
            ITerminateContractInfoCreator terminateContractInfoCreator,
            ITerminateContractValidationService terminateContractValidationService,
            ISessionConnectionFactory sessionConnectionFactory,
            ICrmContractRepository crmContractRepository,
            IContractsManager contractsManager,
            ILegalDeliverableService legalDeliverableService,
            IApprovalOnwardsContractAtomFeedService approvalOnwardsContractAtomFeedService,
            ICorporateContractService corporateContractService)
        {
            _logger = logger;
            _terminateContractInfoCreator = terminateContractInfoCreator;
            _terminateContractValidationService = terminateContractValidationService;
            _sessionConnectionFactory = sessionConnectionFactory;
            _crmContractRepository = crmContractRepository;
            _contractsManager = contractsManager;
            _legalDeliverableService = legalDeliverableService;
            _approvalOnwardsContractAtomFeedService = approvalOnwardsContractAtomFeedService;
            _corporateContractService = corporateContractService;
        }

        public async Task Handle(TerminateContractCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                ContractManagementLoggingEvents.TerminateContractCommandReceived,
                $"Terminate Contract - START: TerminateContractCommand for {message} received");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            TerminateContractInfo terminateContractInfo = _terminateContractInfoCreator.CreateTerminateContractInfo(message.GetContractIdentifier(), connectionInfo);

            Either<RejectionReason, TerminateContractInfo> validationResult = _terminateContractValidationService.Validate(terminateContractInfo);

            await validationResult.MatchAsync(
                leftFunc: rejectionReason =>
            {
                _logger.LogInformation(
                    ContractManagementLoggingEvents.ContractTerminationValidationSuccess,
                    $"Terminate Contract - Validation Failed for {message} because {rejectionReason.WhyFailed} - {rejectionReason.Text}");

                return context.Publish(new ContractTerminationFailedEvent
                {
                    ContractNumber = message.ContractNumber,
                    VersionNumber = message.VersionNumber,
                    SubVersionNumber = message.SubVersionNumber,
                    FailureReason = rejectionReason.Text
                });
            },
                rightFunc: info => AddToFeedAndPublish(context, info, connectionInfo)
                ).ConfigureAwait(false);

            
            _logger.LogInformation(
                ContractManagementLoggingEvents.TerminateContractCommandProcessed,
                $"Terminate Contract - END: TerminateContractCommand for {message} received");
        }

        private async Task AddToFeedAndPublish(IMessageHandlerContext context, TerminateContractInfo terminateContractInfo, ConnectionInfo connectionInfo)
        {
            _logger.LogInformation(
                ContractManagementLoggingEvents.ContractTerminationValidationSuccess,
                $"Terminate Contract - Validation Successful for {terminateContractInfo.ContractIdentifier}");

            ContractIdentifier contractIdentifier = terminateContractInfo.ContractIdentifier; 

            Contract corporateContract = _corporateContractService.GetContract(
                connectionInfo: connectionInfo,
                crmContractRepository: _crmContractRepository,
                contractsManager: _contractsManager,
                legalDeliverableService: _legalDeliverableService,
                contractIdentifier: contractIdentifier);

            corporateContract.SetChildContractsStatusAndSubStatus(newStatus: "Closed", newSubStatus: "Terminated");

            // termination date has to have a value to have passed validation
            corporateContract.SetEndDatesIfEndDatesAreNull(terminateContractInfo.ContractTerminationDate.Value);

            AtomItemCreationResult result =
                _approvalOnwardsContractAtomFeedService.AddContractToFeed(connectionInfo, corporateContract,
                    new Guid(context.MessageId), AtomItemType.ContractTerminated);

            if (result.IsGoodToContinue())
            {
                await context.Publish(new ContractTerminatedEvent
                {
                    ContractNumber = contractIdentifier.ContractNumber,
                    VersionNumber = contractIdentifier.VersionNumber,
                    SubVersionNumber = contractIdentifier.SubVersionNumber,
                    AllocationNumbers = corporateContract.GetAllocationNumbers().ToList()
                });
            }
        }
    }
}