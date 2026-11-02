namespace ContractCreateDomain.Endpoint.ContractCreated
{
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using Infrastructure;
    using NServiceBus;
    using Services.Repositories;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ContractCreatedInCrmHandler : IHandleMessages<ContractCreatedInCrmEvent>
    {
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly ICreatedContractRepository _createdContractRepository;

        public ContractCreatedInCrmHandler(ILogger logger, ISessionConnectionFactory sessionConnectionFactory, ICreatedContractRepository createdContractRepository)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _createdContractRepository = createdContractRepository;
        }

        public async Task Handle(ContractCreatedInCrmEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractCreateDomainEventLoggingId.ContractCreatedInCrmEventReceived, $"Received ContractCreatedInCrmEvent for: {message}");

            var connectionInfo = _sessionConnectionFactory.GetConnection(context);

            var createdContract = new CreatedContract(
                message.ContractNumber,
                message.ContractVersionNumber,
                message.ContractSubVersionNumber,
                CreatedContract.ToAmendmentType(message.AmendmentType),
                message.TotalAllocationCount);

            await _createdContractRepository.Add(createdContract, connectionInfo)
                .ConfigureAwait(false);

            _logger.LogInformation(ContractCreateDomainEventLoggingId.ContractCreatedInCrmEventProcessed, $"Processed ContractCreatedInCrmEvent for: {message}");
        }
    }
}
