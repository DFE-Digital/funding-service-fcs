namespace CrossDomain.Integration.ReportRunnerEndpoint.Handlers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Dtos;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using ContractManagement.DataStore.Repositories;
    using System.Threading.Tasks;

    public class RunReportsAndArchiveExistingCommandHandler : IHandleMessages<RunReportsAndArchiveExistingCommand>
    {
        private readonly IArchiveReportService _archiveReportService;
        private readonly ICdaReportFundingStreamPeriodQueryRepository _reportConfigRepository;
        private readonly ILogger _logger;
        private readonly IDate _dateProvider;

        public RunReportsAndArchiveExistingCommandHandler(ILogger logger, IArchiveReportService archiveReportService, ICdaReportFundingStreamPeriodQueryRepository reportConfigRepository, IDate dateProvider)
        {
            _logger = logger;
            _archiveReportService = archiveReportService;
            _reportConfigRepository = reportConfigRepository;
            _dateProvider = dateProvider;
        }

        public async Task Handle(RunReportsAndArchiveExistingCommand command, IMessageHandlerContext context)
        {
            _logger.LogInformation(CommonLoggingEventId.RunReportsAndArchiveExistingBatchStart, "Beginning handler for running reports and archiving existing");

            string archiveChildFolderName = _archiveReportService.GenerateArchiveChildFolderName();

            _archiveReportService.CreateArchiveRootFolderAndChildFolder(archiveChildFolderName);

            IReadOnlyCollection<ReportConfig> reportConfigs = _reportConfigRepository.GetAllWithinPublicationCloseDate(_dateProvider.GetCalculationDate());

            Func<ReportConfig, IReadOnlyCollection<RunReportCommand>> getRunReportCommands = GetRunReportCommandFactory(command.GenerateLastApprovedReportsOnly);

            foreach (var runReportCommand in reportConfigs.Select(getRunReportCommands).SelectMany(commands => commands))
            {
                runReportCommand.ArchiveChildFolderName = archiveChildFolderName;
                await context.SendLocal(runReportCommand).ConfigureAwait(false);
            }

            _logger.LogInformation(CommonLoggingEventId.RunReportsAndArchiveExistingBatchEnd, "Finished handler for running reports and archiving existing");
        }

        private static Func<ReportConfig, IReadOnlyCollection<RunReportCommand>> GetRunReportCommandFactory(bool shouldGenerateLastApprovedReportsOnly)
        {
            if (shouldGenerateLastApprovedReportsOnly)
            {
                return RunReportCommandCreator.GetLastApprovedVersionRunReportCommands;
            }

            return RunReportCommandCreator.GetRunReportCommands;
        }
    }
}
