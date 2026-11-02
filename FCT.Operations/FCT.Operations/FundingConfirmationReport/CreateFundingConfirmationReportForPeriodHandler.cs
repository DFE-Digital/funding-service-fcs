namespace FCT.Operations.FundingConfirmationReport
{
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using Operations.Extensions;
    using Operations.Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Operations.Common;

    public class CreateFundingConfirmationReportForPeriodHandler : IHandleMessages<CreateFundingConfirmationReportForPeriodCommand>
    {
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IReportService _reportService;
        private readonly IlaReportService _lareportService;
        private readonly IExcelReportGenerator _excelReportGenerator;
        private readonly IWorkbookSharePointRepository _workbookSharePointRepository;

        public CreateFundingConfirmationReportForPeriodHandler(
            ILogger logger,
            ISessionConnectionFactory sessionConnectionFactory,
            IReportService reportService,
            IlaReportService lareportService,
            IExcelReportGenerator excelReportGenerator,
            IWorkbookSharePointRepository workbookSharePointRepository)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _reportService = reportService;
            _lareportService = lareportService;
            _excelReportGenerator = excelReportGenerator;
            _workbookSharePointRepository = workbookSharePointRepository;
        }

        public async Task Handle(CreateFundingConfirmationReportForPeriodCommand message, IMessageHandlerContext context)
        {
            if (message.Type == "CFCR")
            {
                const string folderName = "College Funding Confirmation Report";
                string title = $"College Funding Confirmation - {new DTOs.Period(message.Period)}";
                string filename = $"{title}.xlsx";

                _logger.LogInformation(LoggingEventId.CreateFundingConfirmationReportForPeriodReceived, $"Received CreateFundingConfirmationReportForPeriodCommand: {message}");

                var connectionInfo = _sessionConnectionFactory.GetReplicaConnection();

                var reportRows = await _reportService.GetReportRows(message.Period, connectionInfo);

                var workbook = _excelReportGenerator.GenerateWorkbook(reportRows, title);

                _workbookSharePointRepository.Upload(folderName, filename, workbook.ToBytes());

                _logger.LogInformation(LoggingEventId.CreateFundingConfirmationReportForPeriodProcessed, $"Processed CreateFundingConfirmationReportForPeriodCommand: {message}");
            }
            else
            {
                const string folderName = "LA Funding Confirmation report";
                string title = $"LA Funding Confirmation - {new DTOs.Period(message.Period)}";
                string filename = $"{title}.xlsx";

                _logger.LogInformation(LoggingEventId.CreateFundingConfirmationReportForPeriodReceived, $"Received CreateLAFundingConfirmationReportForPeriodCommand: {message}");

                var connectionInfo = _sessionConnectionFactory.GetReplicaConnection();

                var reportRows = await _lareportService.GetLAReportRows(message.Period, connectionInfo);

                var workbook = _excelReportGenerator.GenerateWorkbook(reportRows, title);

                _workbookSharePointRepository.Upload(folderName, filename, workbook.ToBytes());

                _logger.LogInformation(LoggingEventId.CreateFundingConfirmationReportForPeriodProcessed, $"Processed CreateLAFundingConfirmationReportForPeriodCommand: {message}");
            }

        }
    }
}
