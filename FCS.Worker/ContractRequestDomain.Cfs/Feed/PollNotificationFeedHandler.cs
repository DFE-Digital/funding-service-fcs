namespace ContractRequestDomain.Cfs.Feed
{
    using System.Threading.Tasks;
    using Common;
    using ContractRequestDomain.Cfs.Common.Commands;
    using Infrastructure;
    using NServiceBus;
    using Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class PollNotificationFeedHandler : IHandleMessages<PollNotificationFeedCommand>
    {
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IAllocationNotificationService _allocationNotificationService;

        public PollNotificationFeedHandler(
            ILogger logger,
            ISessionConnectionFactory sessionConnectionFactory,
            IAllocationNotificationService allocationNotificationService,
            IAllocationNotificationRepository allocationNotificationRepository)
        {
            _sessionConnectionFactory = sessionConnectionFactory;
            _logger = logger;
            _allocationNotificationService = allocationNotificationService;
        }

        public async Task Handle(PollNotificationFeedCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractRequestCfsLoggingEvents.PollNotificationFeedCommandReceived, "START: PollNotificationFeedCommand received");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            await _allocationNotificationService.ReadLatestNotifications(connectionInfo, GetMoreNotifications)
                .ConfigureAwait(continueOnCapturedContext: false);

            _logger.LogInformation(ContractRequestCfsLoggingEvents.PollNotificationFeedCommandProcessed, $"END: PollNotificationFeedCommand processed");

            async Task GetMoreNotifications()
            {
                await context.SendLocal(new PollNotificationFeedCommand())
                    .ConfigureAwait(continueOnCapturedContext: false);
            }
        }
    }
}
