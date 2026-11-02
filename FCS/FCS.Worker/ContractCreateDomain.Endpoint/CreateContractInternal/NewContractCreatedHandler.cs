namespace ContractCreateDomain.Endpoint.CreateContractInternal
{
    using System.Threading.Tasks;
    using Infrastructure;
    using Infrastructure.DTOs;
    using Newtonsoft.Json;
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class NewContractCreatedHandler : IHandleMessages<NewContractCreated>
    {
        private readonly ISagaDataStorage _sagaDataStorage;
        private readonly ILogger _logger;

        public NewContractCreatedHandler(
            ISagaDataStorage sagaDataStorage,
            ILogger logger)
        {
            _sagaDataStorage = sagaDataStorage;
            _logger = logger;
        }

        public async Task Handle(NewContractCreated message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractCreateDomainEventLoggingId.ContractCreated, $"NewContractCreatedHandler called {message}");

            SagaStorageValue sagaData = _sagaDataStorage.GetSagaData<SagaStorageValue>(message.CorrelationId);

            CreateContractSagaData createContractSaga = JsonConvert.DeserializeObject<CreateContractSagaData>(sagaData.SagaDataAsJson);

            _logger.LogInformation(ContractCreateDomainEventLoggingId.DocumentGenerationComplete, $"NewContractCreatedHandler received {message}, Intent: {sagaData.Intent}");

            await CreateContractSaga.Handle(context, createContractSaga, _logger)
                .ConfigureAwait(false);
        }
    }
}
