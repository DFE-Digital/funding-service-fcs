namespace ContractCreateDomain.IncrementContractVersionEndpoint.Handlers
{
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Threading.Tasks;

    public class AmendContractUnsuccessfulHandler : IHandleMessages<AmendContractUnsuccessful>
    {
        private readonly ILogger _logger;

        public AmendContractUnsuccessfulHandler(ILogger logger)
        {
            _logger = logger;
        }

        public Task Handle(AmendContractUnsuccessful message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractCreateDomainEventLoggingId.AmendContractUnsuccessfulReceived,
                $"AmendContractUnsuccessful arrived on Version Increment Endpoint - {message}");

            return Task.CompletedTask;
        }
    }
}