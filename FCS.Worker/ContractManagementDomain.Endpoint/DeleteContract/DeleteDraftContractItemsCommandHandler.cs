namespace ContractManagementDomain.Endpoint.DeleteContract
{
    using System.Linq;
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class DeleteDraftContractItemsCommandHandler : IHandleMessages<DeleteDraftContractItemsCommand>
    {
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly ICrmContractRepository _crmContractRepository;
        private readonly ICreatedContractRepository _createdContractRepository;

        public DeleteDraftContractItemsCommandHandler(
            ILogger logger,
            ISessionConnectionFactory sessionConnectionFactory,
            ICrmContractRepository crmContractRepository,
            ICreatedContractRepository createdContractRepository)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _crmContractRepository = crmContractRepository;
            _createdContractRepository = createdContractRepository;
        }

        public async Task Handle(DeleteDraftContractItemsCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.DeleteDraftContractItemsCommandReceived, $"Started processing DeleteDraftContractItemsCommand for: {message}");

            if (_crmContractRepository.IsSingleContractWhichIsNotSupersededDraft(message.ContractNumber, message.VersionNumber))
            {
                ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

                var contractIdentifiers = await _createdContractRepository.GetAllContractsForVersion(
                    message.ContractNumber,
                    message.VersionNumber,
                    connectionInfo);

                await _createdContractRepository.RemoveAllForContractVersion(message.ContractNumber, message.VersionNumber, connectionInfo);

                await context.Send(new DeleteDocumentsForContractCommand
                {
                    ContractNumber = message.ContractNumber,
                    VersionNumber = message.VersionNumber
                });

                var events = contractIdentifiers.Select(ci =>
                    new DraftContractDeletedEvent
                    {
                        ContractNumber = ci.ContractNumber,
                        VersionNumber = ci.VersionNumber,
                        SubVersionNumber = ci.SubVersionNumber
                    }).ToList();

                var publishTasks = events.Select(context.Publish);

                await Task.WhenAll(publishTasks);
            }
            else
            {
                await context.Send(new IssueCrmNotificationCommand
                {
                    ContractNumber = message.ContractNumber,
                    VersionNumber = message.VersionNumber,
                    SubVersionNumber = 0,
                    NotificationText = "multiple instances exist. Please raise an incident with the Service Desk",
                    NotificationType = NotificationType.DeleteDraftContractFailed
                });
            }

            _logger.LogInformation(ContractManagementLoggingEvents.DeleteDraftContractItemsCommandCompleted, $"Completed processing DeleteDraftContractItemsCommand for {message}");
        }
    }
}
