namespace FCT.Operations.PaymentSummary.Handlers
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Aspose.Cells;
    using Extensions;
    using Infrastructure;
    using NServiceBus;
    using Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Operations.Common;
    using SFA.FCT.Operations.Common.Repositories;

    public class CreatePaymentSummaryReportHandler : IHandleMessages<CreatePaymentSummaryReportCommand>
    {
        private readonly ILogger _logger;
        private readonly IOverrideDateRepository _dateProvider;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IPaymentSummaryReportService _paymentSummaryReportService;
        private readonly IPaymentLineSummaryRepository _paymentLineSummaryRepository;
        private readonly IExcelGenerator _excelGenerator;
        private readonly IWorkbookStorageRepository _workbookStorageRepository;

        public CreatePaymentSummaryReportHandler(
            ILogger logger,
            IOverrideDateRepository dateProvider,
            ISessionConnectionFactory sessionConnectionFactory,
            IPaymentSummaryReportService paymentSummaryReportService,
            IExcelGenerator excelGenerator,
            IPaymentLineSummaryRepository paymentLineSummaryRepository,
            IWorkbookStorageRepository workbookStorageRepository)
        {
            _logger = logger;
            _dateProvider = dateProvider;
            _sessionConnectionFactory = sessionConnectionFactory;
            _paymentSummaryReportService = paymentSummaryReportService;
            _excelGenerator = excelGenerator;
            _paymentLineSummaryRepository = paymentLineSummaryRepository;
            _workbookStorageRepository = workbookStorageRepository;
        }

        public async Task Handle(CreatePaymentSummaryReportCommand message, IMessageHandlerContext context)
        {

            
            _logger.LogInformation(LoggingEventId.BeginCreatePaymentSummaryReport, "Received CreatePaymentSummaryReportCommand");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetReplicaConnection();
            DateTime currentTime = await _dateProvider.GetDate(connectionInfo);

            bool shouldGeneratePaymentSummaryReport = await _paymentSummaryReportService.ShouldGeneratePaymentSummaryReport(currentTime, connectionInfo)
                .ConfigureAwait(false);

            if (shouldGeneratePaymentSummaryReport)
            {
                _logger.LogInformation(LoggingEventId.GeneratingPaymentSummaryReport, "Generating PaymentSummaryReport");

                ReportingPeriod reportingPeriod = new ReportingPeriod(currentTime);

                IReadOnlyCollection<PaymentSummaryLine> paymentSummaryLines = await _paymentLineSummaryRepository.GetPaymentSummaryLines(reportingPeriod, connectionInfo)
                    .ConfigureAwait(false);

                IReadOnlyCollection<PaymentSummaryLine> paymentSummary1619Lines = await _paymentLineSummaryRepository.Get1619PaymentSummaryLines(reportingPeriod, connectionInfo)
                   .ConfigureAwait(false);

                paymentSummaryLines = _paymentSummaryReportService.FilterOutUnnecessaryLines(paymentSummaryLines);              


                Workbook workbook = _excelGenerator.GenerateWorkbook(paymentSummaryLines, paymentSummary1619Lines, reportingPeriod, _paymentSummaryReportService);                  

               
                
                string filename = reportingPeriod.ToPaymentSummaryReportFilename();

                _workbookStorageRepository.Upload(workbook, filename);

                var uploadToSharePointCommand = new UploadPaymentSummaryReportToSharePointCommand
                {
                    Filename = filename
                };

                await context.SendLocal(uploadToSharePointCommand)
                    .ConfigureAwait(false);

                _logger.LogInformation(LoggingEventId.GeneratedPaymentSummaryReport, $"Generated PaymentSummaryReport {filename}");
            }

            _logger.LogInformation(LoggingEventId.EndCreatePaymentSummaryReport, "Processed CreatePaymentSummaryReportCommand");
        }
    }
}