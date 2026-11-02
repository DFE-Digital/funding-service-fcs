namespace ContractRequestDomain.Cfs.Feed.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Common;
    using Dtos;
    using Optional;
    using Repositories;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class AllocationNotificationService : IAllocationNotificationService
    {
        private readonly ILogger _logger;
        private readonly IAllocationNotificationRepository _allocationNotificationRepository;
        private readonly IAllocationNotificationFeedReader _allocationNotificationFeedReader;

        public AllocationNotificationService(
            ILogger logger,
            IAllocationNotificationRepository allocationNotificationRepository,
            IAllocationNotificationFeedReader allocationNotificationFeedReader)
        {
            _logger = logger;
            _allocationNotificationRepository = allocationNotificationRepository;
            _allocationNotificationFeedReader = allocationNotificationFeedReader;
        }

        public async Task ReadLatestNotifications(ConnectionInfo connectionInfo, Func<Task> getMoreNotifications)
        {
            Option<Bookmark> currentBookmark = await _allocationNotificationRepository.GetCurrentBookmark(connectionInfo)
                .ConfigureAwait(continueOnCapturedContext: false);

            int feedPageNumberToRequest = currentBookmark.Match(some: bm => bm.FeedPageNumber, none: () => 1);

            AtomPage atomPage = _allocationNotificationFeedReader.GetAtomPage(feedPageNumberToRequest);

            IReadOnlyCollection<AllocationNotification> latestAllocationNotifications = AtomPageTransformer.ToOrderedAllocationNotifications(atomPage);

            if (latestAllocationNotifications.Any())
            {
                await _allocationNotificationRepository.AddRange(connectionInfo, latestAllocationNotifications)
                    .ConfigureAwait(continueOnCapturedContext: false);
            }

            string bookmarkInfo = currentBookmark.Match(some : bm => bm.ToString() , none: () => "No Bookmark");

            _logger.LogInformation(ContractRequestCfsLoggingEvents.AllocationNotificationsRetrieved, 
                $"Retrieved and stored {latestAllocationNotifications.Count} allocation notifications from bookmark: {bookmarkInfo}");
        }
    }
}