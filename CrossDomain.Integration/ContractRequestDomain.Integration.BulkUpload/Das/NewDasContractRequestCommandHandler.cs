namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload.Das
{
    using System.Threading.Tasks;
    using Common;
    using CrossDomain.Integration.Entities.ContractRequest;
    using CrossDomain.Integration.Messages.Commands;
    using Framework.Logging.Interfaces;
    using NServiceBus;
    using Services;

    public class NewDasContractRequestCommandHandler : IHandleMessages<NewDasContractRequestCommand>
    {
        private readonly ILogger _logger;
        private readonly IContractRequestMutator _contractRequestMutator;

        public NewDasContractRequestCommandHandler(
            ILogger logger,
            IContractRequestMutator contractRequestMutator)
        {
            _logger = logger;
            _contractRequestMutator = contractRequestMutator;
        }

        public async Task Handle(NewDasContractRequestCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                ContractRequestDomainEventLoggingId.NewDasContractRequestCommandReceived,
                $"NewDasContractRequestCommand received for {message.DasRequest}");

            contractRequestType contractRequestType = DasRequestTransformer.Transform(message.DasRequest);

            _contractRequestMutator.AddNonLevyAllocationToContractRequest(contractRequestType);

            await context.Send(new NewContractRequestCommand
            {
                ContractRequest = contractRequestType,
                ShouldReply = false,
                DasEngagementEventId = message.DasEngagementEventId
            });

            _logger.LogInformation(
                ContractRequestDomainEventLoggingId.NewDasContractRequestCommandProcessed,
                $"NewDasContractRequestCommand processed for {message.DasRequest}");
        }
    }
}
