namespace ContractManagementDomain.Endpoint.DeleteContract
{
    using System.Threading.Tasks;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class DeleteDocumentsForContractCommandHandler : IHandleMessages<DeleteDocumentsForContractCommand>
    {
        private readonly ILogger _logger;
        private readonly IDeleteDocumentsService _deleteDocumentsService;

        public DeleteDocumentsForContractCommandHandler(IDeleteDocumentsService deleteDocumentsService, ILogger logger)
        {
            _deleteDocumentsService = deleteDocumentsService;
            _logger = logger;
        }

        public async Task Handle(DeleteDocumentsForContractCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.DeleteDocumentsForContractCommandReceived, $"Started processing DeleteDocumentsForContractCommand for: {message}");

            _deleteDocumentsService.DeleteDocumentsForContract(message.ContractNumber, message.VersionNumber);

            await context.Send(new DeleteContractCommand
            {
                ContractNumber = message.ContractNumber,
                VersionNumber = message.VersionNumber
            });

            _logger.LogInformation(ContractManagementLoggingEvents.DeleteDocumentsForContractCommandReceived, $"Completed processing DeleteDocumentsForContractCommand for: {message}");
        }
    }
}
