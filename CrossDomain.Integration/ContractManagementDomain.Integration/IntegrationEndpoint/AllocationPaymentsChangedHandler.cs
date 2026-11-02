namespace SFA.FCT.ContractManagementDomain.Integration.IntegrationEndpoint
{
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Repositories;
    using ContractManagementService.Common;
    using CrossDomain.Integration.Events;
    using Framework.Logging.Interfaces;
    using Infrastructure;
    using NServiceBus;

    public class AllocationPaymentsChangedHandler : IHandleMessages<IAllocationPaymentsChangedOnPostingEvent>, IHandleMessages<AllocationPaymentsChangedOnAggregationEvent>
    {
        private readonly ILogger _logger;
        private readonly IApprovedContractAllocationRepository _approvedContractAllocationRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public AllocationPaymentsChangedHandler
            (ILogger logger,
            IApprovedContractAllocationRepository approvedContractAllocationRepository,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _approvedContractAllocationRepository = approvedContractAllocationRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public Task Handle(IAllocationPaymentsChangedOnPostingEvent message, IMessageHandlerContext context)
        {
            SetOutstandingPaymentsIndicator(message.AllocationNumber, message.HasOutstandingPayments, context,
                nameof(message));

            return Task.CompletedTask;
        }

        public Task Handle(AllocationPaymentsChangedOnAggregationEvent message, IMessageHandlerContext context)
        {
            SetOutstandingPaymentsIndicator(message.AllocationNumber, message.HasOutstandingPayments, context,
                nameof(message));

            return Task.CompletedTask;
        }

        private void SetOutstandingPaymentsIndicator(string allocationNumber, bool hasOutstandingPayments, IMessageHandlerContext context, string typeName)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.AllocationPaymentsChangedEventReceived,
                $"{typeName} received for {allocationNumber}, HasOutstandingPayments: {hasOutstandingPayments} - set outstanding payments indicator");

            var connection = _sessionConnectionFactory.GetConnection(context);

            _approvedContractAllocationRepository.SetOutstandingPaymentsIndicator(allocationNumber, hasOutstandingPayments, connection);

            _logger.LogInformation(ContractManagementLoggingEvents.AllocationPaymentsChangedEventCompleted,
                $"{typeName} completed for {allocationNumber}, HasOutstandingPayments: {hasOutstandingPayments} - set outstanding payments indicator");
        }
    }
}
