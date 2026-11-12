namespace FundingAllocation.Endpoints.DocumentGenerationComplete
{
    using System;
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class DocumentGenerationCompleteHandler : IHandleMessages<DocumentGenerationComplete>
    {
        private readonly ILogger _logger;
        private readonly IContractStorage _contractStorage;

        public DocumentGenerationCompleteHandler(ILogger logger, IContractStorage contractStorage)
        {
            _logger = logger;
            _contractStorage = contractStorage;
        }

        public async Task Handle(DocumentGenerationComplete message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.DocumentGenerationCompleteReceived, $"Processing DocumentGenerationComplete: {message}");

            Contract corpChildContract = message.Contract;

            string storageKey = _contractStorage.GetKey(corpChildContract.contractNumber, corpChildContract.contractVersionNumber, corpChildContract.contractSubVersionNumber);

            ExtendedContractTypeAndIntent masterContractAndIntent = await _contractStorage.GetContract(storageKey);

            // we may need to enrich here: _fundingTypePeriodService.EnrichContract todo:?
            object command = GetObjectToSendToCrm(masterContractAndIntent, message.CorrelationId);
            
            await context.Send(command);

            _logger.LogInformation(LoggingId.DocumentGenerationCompleteProcessed, $"Processed DocumentGenerationComplete: {message}");
        }

        private object GetObjectToSendToCrm(ExtendedContractTypeAndIntent extendedContractTypeAndIntent, string correlationId)
        {
            switch (extendedContractTypeAndIntent.Intent)
            {
                case ContractIntent.New:
                    return new CreateContractCommand
                    {
                        BatchId = Guid.NewGuid().ToString(),
                        CorporateContract = extendedContractTypeAndIntent.Contract,
                        CorrelationId = correlationId
                    };
                case ContractIntent.UpdateDraft:
                case ContractIntent.UpdateDraftAmendment:
                    return new UpdateContractCommand
                    {
                        BatchId = Guid.NewGuid().ToString(),
                        Contract = extendedContractTypeAndIntent.Contract,
                        CorrelationId = correlationId
                    };
                case ContractIntent.RevisedNew:
                case ContractIntent.NewAmendment:
                    return new CreateNewAmendedContractCommand
                    {
                        BatchId = Guid.NewGuid().ToString(),
                        CorporateContract = extendedContractTypeAndIntent.Contract,
                        CorrelationId = correlationId
                    };
                case ContractIntent.Amendment:
                    return new AmendContractCommand
                    {
                        BatchId = Guid.NewGuid().ToString(),
                        Contract = extendedContractTypeAndIntent.Contract,
                        CorrelationId = correlationId
                    };

                default:
                    throw new ArgumentException($"The intent of {extendedContractTypeAndIntent.Intent} is not supported");
            }
        }
    }
}
