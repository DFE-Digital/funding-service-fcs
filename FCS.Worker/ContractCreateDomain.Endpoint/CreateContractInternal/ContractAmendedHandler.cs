namespace ContractCreateDomain.Endpoint.CreateContractInternal
{
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using Infrastructure;
    using Infrastructure.DTOs;
    using Newtonsoft.Json;
    using NServiceBus;
    using Services.Repositories;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ContractAmendedHandler : IHandleMessages<ContractAmended>
    {
        private readonly ILogger _logger;
        private readonly ISagaDataStorage _sagaDataStorage;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly ICreatedContractRepository _createdContractRepository;

        public ContractAmendedHandler(
            ILogger logger,
            ISagaDataStorage sagaDataStorage,
            ISessionConnectionFactory sessionConnectionFactory,
            ICreatedContractRepository createdContractRepository)
        {
            _logger = logger;
            _sagaDataStorage = sagaDataStorage;
            _sessionConnectionFactory = sessionConnectionFactory;
            _createdContractRepository = createdContractRepository;
        }

        public async Task Handle(ContractAmended message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractCreateDomainEventLoggingId.ContractAmendedReceived, $"ContractAmendedHandler received {message}");

            SagaStorageValue sagaData = _sagaDataStorage.GetSagaData<SagaStorageValue>(message.ProcessId);

            _logger.LogInformation(ContractCreateDomainEventLoggingId.ContractAmendedReceived, $"ContractAmendedHandler received {message}, Intent: {sagaData.Intent}");

            ModifyContractSagaData modifyContractSagaData = JsonConvert.DeserializeObject<ModifyContractSagaData>(sagaData.SagaDataAsJson);

            await ModifyContractSaga.Handle(message, context, modifyContractSagaData, _logger).ConfigureAwait(false);
        }
    }
}
