namespace FundingAllocation.Endpoints.BulkUpload
{
    using System;
    using System.Threading.Tasks;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class BulkUploadInProgressHandler : IHandleMessages<BulkUploadInProgressEvent>
    {
        private readonly ILogger _logger;
        private readonly IBulkUploadStatusRepository _bulkUploadStatusRepository;

        public BulkUploadInProgressHandler(ILogger logger, IBulkUploadStatusRepository bulkUploadStatusRepository)
        {
            _logger = logger;
            _bulkUploadStatusRepository = bulkUploadStatusRepository;
        }

        public async Task Handle(BulkUploadInProgressEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.BulkUploadInProgressEventReceived, $"Processing BulkUploadInProgressEvent {message}");

            await _bulkUploadStatusRepository.SetToInProgress(
                Guid.Parse(message.BatchId),
                message.FundingTypeCode,
                message.FundingPeriodName);

            _logger.LogInformation(LoggingId.BulkUploadInProgressEventProcessed, $"Processed BulkUploadInProgressEvent {message}");
        }
    }
}
