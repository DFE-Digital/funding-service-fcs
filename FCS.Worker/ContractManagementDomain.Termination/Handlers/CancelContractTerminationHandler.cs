namespace ContractManagementDomain.Termination.Handlers
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Services;
    using ContractManagementDomain.Termination.Extensions;
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

    public class CancelContractTerminationHandler : IHandleMessages<CancelContractTerminationCommand>
    {
        private readonly ILogger _logger;
        private readonly ICrmContractRepository _crmContractRepository;
        private readonly IContractsManager _contractsManager;
        private readonly ILegalDeliverableService _legalDeliverableService;
        private readonly IApprovalOnwardsContractAtomFeedService _approvalOnwardsContractAtomFeedService;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly ICorporateContractService _corporateContractService;

        public CancelContractTerminationHandler(
            ILogger logger,
            ICrmContractRepository crmContractRepository,
            IContractsManager contractsManager,
            ILegalDeliverableService legalDeliverableService,
            IApprovalOnwardsContractAtomFeedService approvalOnwardsContractAtomFeedService,
            ISessionConnectionFactory sessionConnectionFactory,
            ICorporateContractService corporateContractService)
        {
            _logger = logger;
            _crmContractRepository = crmContractRepository;
            _contractsManager = contractsManager;
            _legalDeliverableService = legalDeliverableService;
            _approvalOnwardsContractAtomFeedService = approvalOnwardsContractAtomFeedService;
            _sessionConnectionFactory = sessionConnectionFactory;
            _corporateContractService = corporateContractService;
        }

        public async Task Handle(CancelContractTerminationCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                ContractManagementLoggingEvents.CancelContractTerminationCommandReceived,
                $"Cancel Contract Termination - START: CancelContractTerminationCommand for {message} received");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            contract corporateContract = _corporateContractService.GetContract(
                connectionInfo: connectionInfo,
                crmContractRepository: _crmContractRepository,
                contractsManager: _contractsManager,
                legalDeliverableService: _legalDeliverableService,
                contractIdentifier: message.GetContractIdentifier());

            corporateContract.RemoveTerminationInformation();
            corporateContract.SetChildContractsSubStatus(newStatus: "Approved");

            AtomItemCreationResult result =
                _approvalOnwardsContractAtomFeedService.AddContractToFeed(connectionInfo, corporateContract,
                    new Guid(context.MessageId), AtomItemType.CancelledContractTermination);

            if (result.IsGoodToContinue())
            {
                ContractTerminationCancelledEvent cancelledEvent = new ContractTerminationCancelledEvent
                {
                    ContractNumber = message.ContractNumber,
                    VersionNumber = message.VersionNumber,
                    SubVersionNumber = message.SubVersionNumber,
                    AllocationNumbers = corporateContract.GetAllocationNumbers().ToList()
                };

                await context.Publish(cancelledEvent);
            }

            _logger.LogInformation(
                ContractManagementLoggingEvents.CancelContractTerminationCommandProcessed,
                $"Cancel Contract Termination - END: CancelContractTerminationCommand for {message} received");
        }
    }
}
