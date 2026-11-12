namespace ContractCreateDomain.Endpoint.CreateContractInternal
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using Infrastructure;
    using Infrastructure.DTOs;
    using Infrastructure.Extensions;
    using Newtonsoft.Json;
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using CR=SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class DocumentGenerationCompleteHandler : IHandleMessages<DocumentGenerationComplete>
    {
        private static readonly IReadOnlyCollection<Intent> ModifySagaIntents = new List<Intent>{ Intent.Update,Intent.UpdateAmendment, Intent.Amendment};
        private static readonly IReadOnlyCollection<Intent> CreateSagaIntents = new List<Intent> { Intent.New, Intent.RevisedNew, Intent.NewAmendment };
        private readonly ISagaDataStorage _sagaDataStorage;
        private readonly ILogger _logger;
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;
        private readonly IFundingTypePeriodService _fundingTypePeriodService;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public DocumentGenerationCompleteHandler(
            ISagaDataStorage sagaDataStorage,
            ILogger logger,
            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository,
            IFundingTypePeriodService fundingTypePeriodService,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _sagaDataStorage = sagaDataStorage;
            _logger = logger;
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
           _fundingTypePeriodService = fundingTypePeriodService;
           _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(DocumentGenerationComplete message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractCreateDomainEventLoggingId.DocumentGenerationComplete, $"DocumentGenerationCompleteHandler received {message}");

            SagaStorageValue sagaData = _sagaDataStorage.GetSagaData<SagaStorageValue>(message.CorrelationId);

            _logger.LogInformation(ContractCreateDomainEventLoggingId.DocumentGenerationComplete, $"DocumentGenerationCompleteHandler received {message}, Intent: {sagaData.Intent}");

            if (ModifySagaIntents.Contains(sagaData.Intent))
            {
                ModifyContractSagaData modifyContractSagaData = JsonConvert.DeserializeObject<ModifyContractSagaData>(sagaData.SagaDataAsJson);

                await ModifyContractSaga.Handle(message,
                    context,
                    modifyContractSagaData,
                    GetUpdateCommandToSaveToCrm(modifyContractSagaData.ExtendedCorporateContract, modifyContractSagaData.BatchId, modifyContractSagaData.ProcessId, sagaData.Intent),
                    _logger,
                    _fundingTypeFundingPeriodQueryRepository,
                    _fundingTypePeriodService,
                    _sessionConnectionFactory)
                    .ConfigureAwait(false);

                // we update this data as the modify saga may have changed it
                SagaStorageValue sagaStorageValue = new SagaStorageValue(sagaData: modifyContractSagaData, intent: sagaData.Intent);
                _sagaDataStorage.UploadSagaData(message.CorrelationId, sagaStorageValue);
            }
            else if(CreateSagaIntents.Contains(sagaData.Intent))
            {
                CreateContractSagaData createContractSaga = JsonConvert.DeserializeObject<CreateContractSagaData>(sagaData.SagaDataAsJson);

                ExtendedContractType extendedContract =
                    createContractSaga.ExtendedContractType.ConvertByteArrayToObject<ExtendedContractType>();

                var childContract = extendedContract.contracts.First();
                var fundingTypeCode = childContract.fundingType.fundingTypeCode;
                var fundingPeriod = childContract.period.GetFundingPeriodName();
                ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);
                FundingTypeFundingPeriod fundingTypeFundingPeriod = _fundingTypeFundingPeriodQueryRepository.Get(fundingTypeCode, fundingPeriod, connectionInfo);
                _fundingTypePeriodService.EnrichContract(extendedContract, fundingTypeFundingPeriod);

                object commandToSaveInCrm = GetNewCommandToSaveToCrm(
                    extendedContract,
                    batchId: createContractSaga.ContractRequestContract.ConvertByteArrayToObject<CR.contractRequestType>()
                        .correlationInfo.batchId,
                    processId: createContractSaga.ProcessId,
                    intent: sagaData.Intent);

                await context.Send(commandToSaveInCrm).ConfigureAwait(false);                
            }
            else
            {
                throw new ArgumentException($"DocumentGenerationComplete cannot be processed intent is not supported: {sagaData.Intent}");
            }
        }

        private object GetNewCommandToSaveToCrm(ExtendedContractType extendedContract, string batchId, string processId,
            Intent intent)
        {
            switch (intent)
            {
                case Intent.New:
                    return new CreateContractCommand
                    {
                        CorrelationId = processId,
                        BatchId = batchId,
                        CorporateContract = extendedContract
                    };
                case Intent.RevisedNew:
                case Intent.NewAmendment:
                    return new CreateNewAmendedContractCommand
                    {
                        CorrelationId = processId,
                        BatchId = batchId,
                        CorporateContract = extendedContract
                    };
                default:
                    throw new ArgumentException($"intent is not supported: {intent}");
            }
        }

        private object GetUpdateCommandToSaveToCrm(byte[] extendedCorporateContract, string batchId, string processId, Intent intent)
        {
            ExtendedContractType extendedContract = extendedCorporateContract.ConvertByteArrayToObject<ExtendedContractType>();

            switch (intent)
            {
                case Intent.Update:
                case Intent.UpdateAmendment:
                    return new UpdateContractCommand
                    {
                        BatchId = batchId,
                        CorrelationId = processId,
                        Contract = extendedContract
                    };
                case Intent.Amendment:
                    return new AmendContractCommand
                    {
                        BatchId = batchId,
                        CorrelationId = processId,
                        Contract = extendedContract
                    };
                  
                default:
                    throw new ArgumentException($"intent is not supported: {intent}");
            }
        }
    }
}
