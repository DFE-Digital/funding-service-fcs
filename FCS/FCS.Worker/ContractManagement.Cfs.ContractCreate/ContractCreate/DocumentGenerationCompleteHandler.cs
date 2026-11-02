namespace ContractManagement.Cfs.ContractCreate
{
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class DocumentGenerationCompleteHandler : IHandleMessages<DocumentGenerationComplete>
    {
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IFundingTypeFundingPeriodEnrichmentService _enrichmentService;
        private readonly IContractCfsAllocationRetrievalService _contractCfsAllocationRetrievalService;

        public DocumentGenerationCompleteHandler(
            ILogger logger,
            IFundingTypeFundingPeriodEnrichmentService enrichmentService,
            IContractCfsAllocationRetrievalService contractCfsAllocationRetrievalService,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _enrichmentService = enrichmentService;
            _contractCfsAllocationRetrievalService = contractCfsAllocationRetrievalService;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(DocumentGenerationComplete message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractManagementCfsLoggingEvents.DocumentGenerationCompleteReceived,
                $"START: DocumentGenerationComplete received for {message}");

            contract corpChildContract = message.Contract;

            string storageKey = _contractCfsAllocationRetrievalService.GetKey(corpChildContract.contractNumber, corpChildContract.contractVersionNumber);

            var contractCfsAllocation = _contractCfsAllocationRetrievalService.GetContractCfsAllocation(storageKey);

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            _enrichmentService.EnrichContract(connectionInfo, contractCfsAllocation.Contract);

            await context.Send(new CreateContractCommand
            {
                BatchId = System.Guid.NewGuid().ToString(),
                CorporateContract = contractCfsAllocation.Contract,
                CorrelationId = message.CorrelationId
            }).ConfigureAwait(continueOnCapturedContext: false);

            _logger.LogInformation(ContractManagementCfsLoggingEvents.DocumentGenerationCompleteProcessed,
                $"END: DocumentGenerationComplete processed for {message}");
        }
    }
}