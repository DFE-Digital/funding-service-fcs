namespace ContractCreateDomain.IncrementContractVersionEndpoint.Handlers
{
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class DocumentGenerationCompleteHandler : IHandleMessages<DocumentGenerationComplete>
    {
        private readonly ILogger _logger;
        private readonly IFundingTypePeriodService _fundingTypePeriodService;
        private readonly IContractStorage _contractStorage;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public DocumentGenerationCompleteHandler(ILogger logger,IFundingTypePeriodService fundingTypePeriodService,
            IContractStorage contractStorage,ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _fundingTypePeriodService = fundingTypePeriodService;
            _contractStorage = contractStorage;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(DocumentGenerationComplete message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractCreateDomainEventLoggingId.IncrementContractVersionDocGenCompleteArrived, $"DocumentGenerationComplete arrived on Version Increment Endpoint - {message}");

            Contract corpChildContract = message.Contract;

            string storageKey = _contractStorage.GetKey(corpChildContract.contractNumber, corpChildContract.contractVersionNumber);

            ExtendedContractType extendedContractType = _contractStorage.GetContract(storageKey);

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            await _fundingTypePeriodService.EnrichContract(extendedContractType, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

            AmendContractCommand command = new AmendContractCommand
            {
                BatchId = System.Guid.NewGuid().ToString(),
                Contract = extendedContractType,
                CorrelationId = message.CorrelationId
            };

            await context.Send(command).ConfigureAwait(false);

            _logger.LogInformation(ContractCreateDomainEventLoggingId.IncrementContractVersionDocGenCompleteProcessed, $"DocumentGenerationComplete processed on Version Increment Endpoint - {message}");

        }
    }
}