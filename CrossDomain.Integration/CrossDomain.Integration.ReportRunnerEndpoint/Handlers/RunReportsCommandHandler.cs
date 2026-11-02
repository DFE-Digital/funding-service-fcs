namespace CrossDomain.Integration.ReportRunnerEndpoint.Handlers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Dtos;
    using ContractManagement.DataStore.Repositories;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class RunReportsCommandHandler : IHandleMessages<RunReportsCommand>
    {
        private readonly ILogger _logger;
        private readonly ICdaReportFundingStreamPeriodQueryRepository _reportConfigRepository;
        private readonly IDate _dateProvider;

        public RunReportsCommandHandler(ILogger logger, ICdaReportFundingStreamPeriodQueryRepository reportConfigRepository, IDate dateProvider)
        {
            _logger = logger;
            _reportConfigRepository = reportConfigRepository;
            _dateProvider = dateProvider;
        }

        public async Task Handle(RunReportsCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(CommonLoggingEventId.RunReportBatchStart, "Beginning run report pro..");
            IReadOnlyCollection<ReportConfig> reportConfigs = _reportConfigRepository.GetAllWithinPublicationCloseDate(_dateProvider.GetCalculationDate());

            int deferralSeconds = 0;
            const int intervalSeconds = 5;

            foreach (var command in reportConfigs.Select(RunReportCommandCreator.GetRunReportCommands).SelectMany(commands => commands))
            {
                var sendOptions = new SendOptions();

                sendOptions.DelayDeliveryWith(TimeSpan.FromSeconds(deferralSeconds));

                await context.Send(command, sendOptions)
                    .ConfigureAwait(false);

                deferralSeconds += intervalSeconds;
            }
        }
    }
}
