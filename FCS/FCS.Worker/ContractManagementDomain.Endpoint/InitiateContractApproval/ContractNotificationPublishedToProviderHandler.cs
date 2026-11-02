namespace ContractManagementDomain.Endpoint.InitiateContractApproval
{
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Repositories;
    using Endpoint.Services;
    using Infrastructure;
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ContractNotificationPublishedToProviderHandler : InitiateContractApprovalBase, IHandleMessages<ContractNotificationPublishedToProviderEvent>
    {
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public ContractNotificationPublishedToProviderHandler(
            ILogger logger,
            ISessionConnectionFactory sessionConnectionFactory,
            IMonthEndHistoryRepository monthEndHistoryRepository,
            IFundingTypeFundingPeriodService fundingTypeFundingPeriodService,
            IXrmManager xrmManager,
            IContractsManager contractManager)
        : base(logger, monthEndHistoryRepository, fundingTypeFundingPeriodService, xrmManager, contractManager)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(ContractNotificationPublishedToProviderEvent message, IMessageHandlerContext context)
        {
            var masterContract = message.CorporateContract;
            var contract = masterContract.contracts.First();

            _logger.LogInformation(
              ContractManagementLoggingEvents.ContractNotificationPublishedToProviderEventReceived, $"InitiateContractApprovalCommand received for MasterContractNumber:[{masterContract.contractNumber}] ContractNumber:[{contract.contractNumber}] ContractVersionNumber:[{contract.contractVersionNumber}]");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            if (ShouldDefer(contract.contractVersionNumber, connectionInfo))
            {
                _logger.LogInformation(
                    ContractManagementLoggingEvents.InitiateContractApprovalHandlerDeferDueToMonthEndProcessing,
                    $"ContractNotificationPublishedToProviderEvent for MasterContractNumber:[{message.CorporateContract.contractNumber}] ContractNumber:[{contract.contractNumber}] ContractVersionNumber:[{contract.contractVersionNumber}] deferred due to month-end processing");

                SendOptions sendOptions = new SendOptions();
                sendOptions.DelayDeliveryWith(GetDeferralTimeSpan());
                sendOptions.RouteToThisEndpoint();
                sendOptions.DoNotEnforceBestPractices();

                await context.Send(message, sendOptions);
            }
            else
            {

                await InitiateApproval(
                    masterContract.contractNumber,
                    contract.contractNumber,
                    contract.contractVersionNumber,
                    ApprovalRequestSource.Auto,
                    connectionInfo,
                    context);
            }
        }
    }
}
