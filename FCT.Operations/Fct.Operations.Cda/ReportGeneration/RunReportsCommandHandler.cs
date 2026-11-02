namespace FCT.Operations.Cda.ReportGeneration
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Extensions;
    using Infrastructure;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Dtos;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class RunReportsCommandHandler : 
        IHandleMessages<RunReportsCommand>,
        IHandleMessages<RunReportsAndArchiveExistingCommand>
    {
        private readonly ILogger _logger;
        private readonly ICdaConfigRepository _cdaConfigRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public RunReportsCommandHandler(ILogger logger, ICdaConfigRepository cdaConfigRepository, ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _cdaConfigRepository = cdaConfigRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public int BatchSize => 2;

        public async Task Handle(RunReportsCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingIds.StartingRunReportsCommandHandler, $"Start RunReportsCommandHandler");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);
            var cdaExtractConfigs = await _cdaConfigRepository.GetAllCdaExtracts(connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

            var reportExtractGroups = cdaExtractConfigs.Select(e =>
                    new ReportExtractGroup
                    {
                        ExtractName = e.ExtractName,
                        ArchiveClosedContracts = e.ArchiveClosedContracts,
                        FspCodes = e.CdaReportFundingStreamPeriods.Select(f => f.FundingStreamPeriodCode).ToList()
                    }).ToList();

            List<Task> sendTasks = new List<Task>();
            reportExtractGroups.Batch(BatchSize).ToList().ForEach(batchOfExtracts =>
            {
                batchOfExtracts = batchOfExtracts.ToList();
                sendTasks.Add(context.Send(new CreateReportFromCrmForGroupCommand
                {
                    ExtractGroups = batchOfExtracts,
                    IsLatest = true
                }));

                sendTasks.Add(context.Send(new CreateReportFromCrmForGroupCommand
                {
                    ExtractGroups = batchOfExtracts,
                    IsLatest = false
                }));
            });

            await Task.WhenAll(sendTasks);

            _logger.LogInformation(LoggingIds.FinishedRunReportsCommandHandler, $"Finish RunReportsCommandHandler");
        }

        public async Task Handle(RunReportsAndArchiveExistingCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingIds.StartingRunReportsAndArchiveCommandHandler, $"Start RunReportsCommandHandler");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);
            var cdaExtractConfigs = await _cdaConfigRepository.GetAllCdaExtracts(connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

            var reportExtractGroups = cdaExtractConfigs.Select(e =>
                new ReportExtractGroup
                {
                    ExtractName = e.ExtractName,
                    FspCodes = e.CdaReportFundingStreamPeriods.Select(f => f.FundingStreamPeriodCode).ToList()
                }).ToList();

            List<Task> sendTasks = new List<Task>();
            reportExtractGroups.Batch(BatchSize).ToList().ForEach(batchOfExtracts =>
            {
                batchOfExtracts = batchOfExtracts.ToList();
                if (!message.GenerateLastApprovedReportsOnly)
                {
                    sendTasks.Add(context.Send(new CreateReportFromCrmForGroupCommand
                    {
                        ExtractGroups = batchOfExtracts,
                        ShouldArchive = true,
                        IsLatest = true
                    }));
                }

                // always generate last approved
                sendTasks.Add(context.Send(new CreateReportFromCrmForGroupCommand
                {
                    ExtractGroups = batchOfExtracts,
                    ShouldArchive = true,
                    IsLatest = false
                }));
            });

            await Task.WhenAll(sendTasks);

            _logger.LogInformation(LoggingIds.FinishedRunReportsAndArchiveCommandHandler, $"Finish RunReportsCommandHandler");
        }
    }
}