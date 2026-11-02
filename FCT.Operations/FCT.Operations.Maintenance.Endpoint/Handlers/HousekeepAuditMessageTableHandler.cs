namespace SFA.FCT.Operations.Maintenance.Endpoint.Handlers
{
    using System;
    using System.Threading.Tasks;
    using Common;
    using CrossDomain.Integration.Messages.Commands;
    using Framework.Logging.Interfaces;
    using NServiceBus;
    using Repositories;

    public class HousekeepAuditMessageTableHandler : IHandleMessages<HousekeepAuditMessageTable>
    {
        private readonly ILogger _logger;
        private readonly IAuditMessageDeleteRepository _auditMessageDeleteRepository;

        private const int NoOfDaysForKeepingAuditMessageRecords = 120;

        public HousekeepAuditMessageTableHandler(ILogger logger, IAuditMessageDeleteRepository auditMessageDeleteRepository)
        {
            _logger = logger;
            _auditMessageDeleteRepository = auditMessageDeleteRepository;
        }

        public async Task Handle(HousekeepAuditMessageTable message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingEventId.HousekeepAuditMessageTableStart, "HousekeepAuditMessageTable arrived");

            var houseKeepRowsOlderThanDate = DateTime.UtcNow.Date.AddDays(-NoOfDaysForKeepingAuditMessageRecords).Date;

            await _auditMessageDeleteRepository.HousekeepAuditMessageTable(houseKeepRowsOlderThanDate).ConfigureAwait(continueOnCapturedContext: false);

            _logger.LogInformation(LoggingEventId.HousekeepAuditMessageTableFinish, "HousekeepAuditMessageTable completed");
        }
    }
}