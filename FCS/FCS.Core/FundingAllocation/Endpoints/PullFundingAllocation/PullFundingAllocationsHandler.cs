namespace FundingAllocation.Endpoints.PullFundingAllocation
{
    using System.Linq;
    using System.Threading.Tasks;
    using NServiceBus;
    using Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class PullFundingAllocationsHandler : IHandleMessages<PullFundingAllocationsCommand>
    {
        private readonly ILogger _logger;
        private readonly IFundingAllocationPageControlRepository _pageControlRepository;
        private readonly IFundingNotificationApi _fundingNotificationApi;
        private readonly IFeedReadRepository _feedReadRepository;
        private readonly IJobCompleteRepository _jobCompleteRepository;

        public PullFundingAllocationsHandler(
            ILogger logger,
            IFundingAllocationPageControlRepository pageControlRepository,
            IFundingNotificationApi fundingNotificationApi,
            IFeedReadRepository feedReadRepository,
            IJobCompleteRepository jobCompleteRepository)
        {
            _logger = logger;
            _pageControlRepository = pageControlRepository;
            _fundingNotificationApi = fundingNotificationApi;
            _feedReadRepository = feedReadRepository;
            _jobCompleteRepository = jobCompleteRepository;
        }

        public async Task Handle(PullFundingAllocationsCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.StartPullFundingAllocationsCommand, "Processing PullFundingAllocationsCommand");

            var lastJobCompleted = await _feedReadRepository.HasLastJobCompleted();

            if (!lastJobCompleted)
            {
                _logger.LogInformation(LoggingId.StartPullFundingAllocationsCommand, "Cannot proceed with Processing PullFundingAllocations, last feed job not complete");
                return;
            }

            // Get the most recent bookmark and page
            var latestPageControl = await _pageControlRepository.GetLatest();
            _logger.LogInformation("PullFundingAllocationsHandler - got latest");

            // get the latest page
            var latestPageData = await _fundingNotificationApi.GetLatestPageData();
            _logger.LogInformation($"PullFundingAllocationsHandler - latestPageControl?.PageNumber: {latestPageControl?.PageNumber}, latestPageData.PageNumber: {latestPageData.PageNumber}");
            var pageNumbers = PageNumberCreator.GetPageNumbers(latestPageControl?.PageNumber ?? 1, latestPageData.PageNumber);

            int readId = await _feedReadRepository.CreateRead();

            var getPageCommandMessages
                = pageNumbers.Select(pageNumber => new GetFundingAllocationsPageCommand
            {
                PageNumber = pageNumber,
                ReadId = readId,
                AtomItems = pageNumber == latestPageData.PageNumber ? latestPageData.AtomItems : new AtomItem[0]
            }).ToList();

            foreach (var getPageCommandMessage in getPageCommandMessages)
            {
                await _pageControlRepository.InsertPage(getPageCommandMessage.ReadId, getPageCommandMessage.PageNumber);
            }

            var sendTasks = getPageCommandMessages.Select(context.Send).ToList();

            await Task.WhenAll(sendTasks);

            if (!await _pageControlRepository.IsThereAnyNewDataToConsume(latestPageData.AtomItems.Select(a => a.FundingId).ToList(), latestPageData.PageNumber))
            {
                _logger.LogInformation(LoggingId.StartPullFundingAllocationsCommand, $"No more new data to consume for page {latestPageData.PageNumber}");

                await _jobCompleteRepository.SetCfsReadComplete(readId);

                await context.Send(new JobCompletedCommand(readId));
            }

            _logger.LogInformation(LoggingId.EndPullFundingAllocationsCommand, "Processed PullFundingAllocationsCommand");
        }
    }
}
