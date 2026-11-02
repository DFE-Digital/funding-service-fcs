namespace ContractCreateDomain.Endpoint.CreateContractInternal
{
    using System.Threading.Tasks;
    using Infrastructure;
    using Infrastructure.DTOs;
    using Newtonsoft.Json;
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class AmendContractUnsuccessfulHandler : IHandleMessages<AmendContractUnsuccessful>
    {
        private readonly ILogger _logger;
        private readonly ISagaDataStorage _sagaDataStorage;

        public AmendContractUnsuccessfulHandler(ILogger logger, ISagaDataStorage sagaDataStorage)
        {
            _logger = logger;
            _sagaDataStorage = sagaDataStorage;
        }

        public async Task Handle(AmendContractUnsuccessful message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractCreateDomainEventLoggingId.DocumentGenerationComplete, $"AmendContractUnsuccessfulHandler received {message}");

            SagaStorageValue sagaData = _sagaDataStorage.GetSagaData<SagaStorageValue>(message.Error.correlationId);

            _logger.LogInformation(ContractCreateDomainEventLoggingId.DocumentGenerationComplete, $"AmendContractUnsuccessfulHandler received {message}, Intent: {sagaData.Intent}");

            ModifyContractSagaData modifyContractSagaData = JsonConvert.DeserializeObject<ModifyContractSagaData>(sagaData.SagaDataAsJson);

            await ModifyContractSaga.Handle(message, context, modifyContractSagaData, _logger).ConfigureAwait(false);
        }
    }
}
