namespace OrganisationDomain.Endpoint.Xrm
{
    using System.Threading.Tasks;
    using Common;
    using Integration.Messages.Commands;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class CreateProviderUpdatedNotificationHandler : IHandleMessages<CreateProviderUpdatedNotificationCommand>
    {
        private readonly ILogger _logger;
        private readonly IProviderNotificationRepository _providerNotificationRepository;

        public CreateProviderUpdatedNotificationHandler(ILogger logger, IProviderNotificationRepository providerNotificationRepository)
        {
            _logger = logger;
            _providerNotificationRepository = providerNotificationRepository;
        }

        public Task Handle(CreateProviderUpdatedNotificationCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(OrganisationDomainEventLoggingId.CreateProviderUpdatedNotificationStart,
                $"Started creation of CRM notification: {message}");

            _providerNotificationRepository.CreateProviderDetailsUpdatedNotification(message.Ukprn, message.Notification);

            _logger.LogInformation(OrganisationDomainEventLoggingId.CreateProviderUpdatedNotificationComplete,
                $"Completed creation of CRM notification: {message}");

            return Task.CompletedTask;
        }
    }
}
