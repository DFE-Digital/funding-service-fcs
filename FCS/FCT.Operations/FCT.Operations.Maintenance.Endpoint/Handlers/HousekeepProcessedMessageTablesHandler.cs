namespace SFA.FCT.Operations.Maintenance.Endpoint.Handlers
{
    using System;
    using System.Threading.Tasks;
    using Common;
    using CrossDomain.Integration.Messages.Commands;
    using Framework.Logging.Interfaces;
    using NServiceBus;
    using Repositories;

    public class HousekeepProcessedMessageTablesHandler : IHandleMessages<HousekeepProcessedMessageTables>
    {
        private readonly ILogger _logger;
        private readonly ISchemaQueryRepository _schemaQueryRepository;
        private readonly IProcessedMessageDeleteRepository _processedMessageDeleteRepository;

        private const int NoOfDaysForKeepingProcessedMessageRecords = 120;  

        public HousekeepProcessedMessageTablesHandler(ILogger logger, ISchemaQueryRepository schemaQueryRepository, IProcessedMessageDeleteRepository processedMessageDeleteRepository)
        {
            _logger = logger;
            _schemaQueryRepository = schemaQueryRepository;
            _processedMessageDeleteRepository = processedMessageDeleteRepository;
        }

        public async Task Handle(HousekeepProcessedMessageTables message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingEventId.HousekeepProcessedMessageTablesStart, "HousekeepProcessedMessageTables arrived");

            var houseKeepRowsOlderThanDate = DateTime.UtcNow.Date.AddDays(-NoOfDaysForKeepingProcessedMessageRecords).Date;

            var schemaNames = await _schemaQueryRepository.GetSchemaNamesWithProcessedMessageTable().ConfigureAwait(continueOnCapturedContext: false);

            foreach (var schemaName in schemaNames)
            {
                _logger.LogInformation(LoggingEventId.HousekeepProcessedMessageTableAction, $"Housekeeping {schemaName}.ProcessedMessage Table");
                await _processedMessageDeleteRepository.HousekeepProcessedMessageTable(schemaName, houseKeepRowsOlderThanDate).ConfigureAwait(continueOnCapturedContext: false);
            }
            
            _logger.LogInformation(LoggingEventId.HousekeepProcessedMessageTablesFinish, "HousekeepProcessedMessageTables completed");
        }
    }
}