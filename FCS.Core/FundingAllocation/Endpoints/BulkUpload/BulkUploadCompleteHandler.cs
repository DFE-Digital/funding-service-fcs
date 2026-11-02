namespace FundingAllocation.Endpoints.BulkUpload
{
    using System;
    using System.Threading.Tasks;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class BulkUploadCompleteHandler : IHandleMessages<BulkUploadCompleteEvent>
    {
        private readonly ILogger _logger;
        private readonly IBulkUploadStatusRepository _bulkUploadStatusRepository;

        public BulkUploadCompleteHandler(ILogger logger, IBulkUploadStatusRepository bulkUploadStatusRepository)
        {
            _logger = logger;
            _bulkUploadStatusRepository = bulkUploadStatusRepository;
        }

        public async Task Handle(BulkUploadCompleteEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.BulkUploadCompleteEventReceived, $"Processing BulkUploadCompleteEvent {message}");

            await _bulkUploadStatusRepository.SetToLoaded(message.BatchId);

            _logger.LogInformation(LoggingId.BulkUploadCompleteEventProcessed, $"Processed BulkUploadCompleteEvent {message}");
        }
    }
}
