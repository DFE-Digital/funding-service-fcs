namespace ContractCreateDomain.IncrementContractVersionEndpoint.Handlers
{
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Threading.Tasks;
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;

    /// <summary>
    /// This class is here as it processes a 'reply message' to avoid an error
    /// </summary>
    public class ContractAmendedHandler : IHandleMessages<ContractAmended>
    {
        private readonly ILogger _logger;
        
        public ContractAmendedHandler(ILogger logger)
        {
            _logger = logger;
        }

        public Task Handle(ContractAmended message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractCreateDomainEventLoggingId.IncrementContractVersionContractAmendedArrived,
                $"ContractAmended arrived on Version Increment Endpoint - {message}");

            return Task.CompletedTask;
        }
    }
}
