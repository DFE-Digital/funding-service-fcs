namespace SFA.FCT.Operations.Maintenance.Endpoint.Handlers
{
    using System.Threading.Tasks;
    using NServiceBus;
    using Common;
    using CrossDomain.Integration.Messages.Commands;
    using Framework.Logging.Interfaces;
    using Services;

    public class MaintainAuditQueueHandler : IHandleMessages<MaintainAuditQueueCommand>
    {
        private const string AuditQueueName = "audit";
        private const long DesiredAuditQueueSizeInBytes = 3000000000; // 3 GB
        private const int NumberOfMessagesToDelete = 250;

        private readonly ILogger _logger;
        private readonly IAzureServiceBusQueueService _azureServiceBusQueueService;

        public MaintainAuditQueueHandler(ILogger logger, IAzureServiceBusQueueService azureServiceBusQueueService)
        {
            _logger = logger;
            _azureServiceBusQueueService = azureServiceBusQueueService;
        }

        public async Task Handle(MaintainAuditQueueCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingEventId.MaintainAuditQueueStart, "MaintainAuditQueueCommand arrived");

            long auditQueueSizeInBytes = await _azureServiceBusQueueService.GetQueueSizeInBytes(AuditQueueName);

            if (auditQueueSizeInBytes > DesiredAuditQueueSizeInBytes)
            {
                _logger.LogInformation(LoggingEventId.MaintainAuditQueueDesiredSizeExceeded,
                    $"Queue '{AuditQueueName}' size {auditQueueSizeInBytes} bytes exceeds desired size {DesiredAuditQueueSizeInBytes} bytes, deleting up to {NumberOfMessagesToDelete} messages");

                await _azureServiceBusQueueService.DeleteMessagesFromQueue(AuditQueueName, NumberOfMessagesToDelete);

                SendOptions options = new SendOptions();
                options.RouteToThisEndpoint();

                await context.Send(new MaintainAuditQueueCommand(), options);
            }

            _logger.LogInformation(LoggingEventId.MaintainAuditQueueFinish, "MaintainAuditQueueCommand completed");
        }
    }
}
