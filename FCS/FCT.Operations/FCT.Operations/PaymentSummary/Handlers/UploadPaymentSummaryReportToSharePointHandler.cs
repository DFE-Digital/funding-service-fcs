namespace FCT.Operations.PaymentSummary.Handlers
{
    using System.Threading.Tasks;
    using FCT.Operations.Repositories;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Operations.Common;

    public class UploadPaymentSummaryReportToSharePointHandler : IHandleMessages<UploadPaymentSummaryReportToSharePointCommand>
    {
        private readonly ILogger _logger;
        private readonly IWorkbookStorageRepository _workbookStorageRepository;
        private readonly IWorkbookSharePointRepository _workbookSharePointRepository;

        public UploadPaymentSummaryReportToSharePointHandler(
            ILogger logger,
            IWorkbookStorageRepository workbookStorageRepository,
            IWorkbookSharePointRepository workbookSharePointRepository)
        {
            _logger = logger;
            _workbookStorageRepository = workbookStorageRepository;
            _workbookSharePointRepository = workbookSharePointRepository;
        }

        public Task Handle(UploadPaymentSummaryReportToSharePointCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingEventId.BeginUploadPaymentSummaryReportToSharePoint, $"Received UploadPaymentSummaryReportToSharePointCommand for {message}");

            const string folderName = "Consolidated Payment Summary";

            byte[] fileBytes = _workbookStorageRepository.GetWorkbookBytes(message.Filename);

            _workbookSharePointRepository.Upload(folderName, message.Filename, fileBytes);

            _logger.LogInformation(LoggingEventId.EndUploadPaymentSummaryReportToSharePoint, $"Processed UploadPaymentSummaryReportToSharePointCommand for {message}");

            return Task.CompletedTask;
        }
    }
}
