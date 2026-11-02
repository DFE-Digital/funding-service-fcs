namespace SFA.FCT.Operations.Integrity.Handlers
{
    using System.Threading.Tasks;
    using CrossDomain.Integration.Messages.Commands;
    using Framework.Logging.Interfaces;
    using NServiceBus;
    using Services;

    public class CheckForDuplicateContractsHandler : IHandleMessages<CheckForDuplicateContractsCommand>
    {
        private readonly ILogger _logger;
        private readonly ICrmDuplicateContractService _crmDuplicateContractService;

        public CheckForDuplicateContractsHandler(ILogger logger, ICrmDuplicateContractService crmDuplicateContractService)
        {
            _logger = logger;
            _crmDuplicateContractService = crmDuplicateContractService;
        }

        public Task Handle(CheckForDuplicateContractsCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(IntegrityLoggingIds.CheckForDuplicateContractsCommandReceived, "CheckForDuplicateContractsCommand received");

            _crmDuplicateContractService.IdentifyNewDuplicateContracts(_logger);

            _logger.LogInformation(IntegrityLoggingIds.CheckForDuplicateContractsCommandProcessed, "CheckForDuplicateContractsCommand processed");

            return Task.FromResult(0);
        }
    }
}
