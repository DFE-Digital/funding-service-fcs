namespace AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint
{
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using SFA.FCT.AllocationDeliveryDomain.Common;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ContractTerminationCancelledHandler : IHandleMessages<ContractTerminationCancelledEvent>
    {
        private readonly ILogger _logger;
        private readonly IAllocationUnderTerminationRepository _allocationUnderTerminationRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public ContractTerminationCancelledHandler(
            ILogger logger,
            IAllocationUnderTerminationRepository allocationUnderTerminationRepository,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _allocationUnderTerminationRepository = allocationUnderTerminationRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(ContractTerminationCancelledEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.ContractTerminationCancelledHandlerStarted, $"ContractTerminationCancelledHandler processing started - {message}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            await _allocationUnderTerminationRepository.RemoveAllocationUnderTerminationsForContract(message.ContractNumber, connectionInfo)
                .ConfigureAwait(continueOnCapturedContext: false);

            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.ContractTerminationCancelledHandlerEnded, $"ContractTerminationCancelledHandler processing complete - {message}");
        }
    }
}