namespace FCT.Operations.Cda.ReportGeneration
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dtos;
    using Infrastructure;
    using NServiceBus;
    using ReportUpload;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class CreateReportFromCrmForGroupHandler : IHandleMessages<CreateReportFromCrmForGroupCommand>
    {
        private readonly ILogger _logger;
        private readonly IArchiveFolderCreator _archiveFolderCreator;
        private readonly IProcessedMessageRepository _processedMessageRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IReportUploadService _reportUploadService;
        private readonly ICrmCdaRepository _crmCdaRepository;
        private readonly IReportCreationService _reportCreationService;
        private readonly IClosedReportService _closedReportService;

        public CreateReportFromCrmForGroupHandler(
                ILogger logger,
                IArchiveFolderCreator archiveFolderCreator,
                IProcessedMessageRepository processedMessageRepository,
                ISessionConnectionFactory sessionConnectionFactory,
                IReportUploadService reportUploadService,
                ICrmCdaRepository crmCdaRepositor,
                IReportCreationService reportCreationService, 
                IClosedReportService closedReportService)
        {
            _logger = logger;
            _archiveFolderCreator = archiveFolderCreator;
            _processedMessageRepository = processedMessageRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
            _reportUploadService = reportUploadService;
            _crmCdaRepository = crmCdaRepositor;
            _reportCreationService = reportCreationService;
            _closedReportService = closedReportService;
        }

        public async Task Handle(CreateReportFromCrmForGroupCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingIds.StartingCreateReportFromCrmForGroupHandler, $"Start handler for CreateReportFromCrmForGroupCommand: {message}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            if (_processedMessageRepository.Add(context.MessageId, EndpointConfig.EndpointName, connectionInfo))
            {
                string archiveFolderName = null;
                if (message.ShouldArchive)
                {
                    archiveFolderName = _archiveFolderCreator.GenerateArchiveChildFolderName();

                    _archiveFolderCreator.CreateArchiveRootFolderAndChildFolder(archiveFolderName);
                }

                var batchOfExtracts = message.ExtractGroups.ToList();
                var fspsInBatch = batchOfExtracts.SelectMany(g => g.FspCodes).ToList();

                IReadOnlyCollection<CdaRow> rows = await _crmCdaRepository.GetRows(fspsInBatch, message.IsLatest);

                string fsps = string.Join(",", fspsInBatch);
                _logger.LogInformation(LoggingIds.CreateReportFromCrmForGroupHandlerGotRows,
                    $"Got {rows.Count} rows from Crm for CreateReportFromCrmForGroupCommand: {string.Join(", ", batchOfExtracts.Select(b => b.ExtractName))} Fsps: {fsps}");

                var reports = await _reportCreationService.GetReports(rows, batchOfExtracts, isLatest: message.IsLatest,connectionInfo);

                // upload the reports then send the messages to sharepoint handler
                reports.Where(r => r.IsArchiveClosedContractReport == false).ToList().ForEach(r =>
                {
                    _logger.LogInformation(LoggingIds.StartingUploadReportToSharePoint,
                        $"Uploading file {r.ReportName} to sharepoint");
                    if (message.ShouldArchive)
                    {
                        _reportUploadService.WriteFileToArchiveFolder(fileName: r.ReportName, archiveChildFolderName: archiveFolderName);
                    }

                    // we would like to send a message here but the system runs out of memory
                   _reportUploadService.UploadReportToSharePoint(r);

                    _logger.LogInformation(LoggingIds.FinishedUploadReportToSharePoint,
                        $"Uploaded file {r.ReportName} to sharepoint");
                });
                
                reports.Where(r => r.IsArchiveClosedContractReport).ToList().ForEach(archiveReport =>
                {
                    _logger.LogInformation(LoggingIds.StartingUploadClosedReportToSharePoint,
                        $"Starting uploading Closed CDA Report '{archiveReport}' to SharePoint");

                    _closedReportService.UploadReportToSharePointIfNecessary(archiveReport);

                    _logger.LogInformation(LoggingIds.FinishedUploadClosedReportToSharePoint,
                        $"Completed uploading Closed CDA Report '{archiveReport}' to SharePoint");
                });
            }

            _logger.LogInformation(LoggingIds.FinishedCreateReportFromCrmForGroupHandler, $"Finish handler for CreateReportFromCrmForGroupCommand: {message}");
        }
    }
}
