namespace SFA.FCT.ContractManagementService.Controllers
{
    using AtomFeed;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Common.Atom;
    using CrossDomain.Integration.Common.PagedStorage;
    using FCS.Worker.Common;
    using Microsoft.AspNetCore.Authorization;
    using Microsoft.AspNetCore.Mvc;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.ServiceModel.Syndication;
    using global::ContractManagementService.Infrastructure;

    [ApiController]
    [Authorize]
    [Route(RoutePrefix)]
    public class ContractNotificationFeedController : ControllerBase
    {
        public const string RoutePrefix = "api/contracts/notifications";
        private const string FeedAuthor = "Contract Management Service";
        private const string MediaType = "application/vnd.sfa.contract.v1+atom+xml";
        
        private readonly IApprovedContractAtomItemRepository _contractApprovedAtomItemRepository;
        private readonly IDraftContractAtomItemRepository _draftContractAtomItemRepository;
        private readonly IAllContractAtomItemRepository _allContractAtomItemRepository;
        private readonly SFA.FCT.ContractManagementService.AtomFeed.IAtomFeedGenerator<AtomFeedItem> _atomFeedGenerator;
        private readonly IPageNumberMutator _pageNumberMutator;
        private readonly IApprovalOnwardsContractAtomItemRepository _approvalOnwardsContractAtomItemRepository;
        private readonly IFcsConfiguration _configuration;
       
        public ContractNotificationFeedController(IApprovedContractAtomItemRepository contractApprovedAtomItemRepository,
            SFA.FCT.ContractManagementService.AtomFeed.IAtomFeedGenerator<AtomFeedItem> atomFeedGenerator, 
            IPageNumberMutator pageNumberMutator, 
            IDraftContractAtomItemRepository draftContractAtomItemRepository,
            IAllContractAtomItemRepository allContractAtomItemRepository, 
            IApprovalOnwardsContractAtomItemRepository approvalOnwardsContractAtomItemRepository,
            IFcsConfiguration configuration)
        {
            _contractApprovedAtomItemRepository = contractApprovedAtomItemRepository;
            _draftContractAtomItemRepository = draftContractAtomItemRepository;
            _allContractAtomItemRepository = allContractAtomItemRepository;
            _approvalOnwardsContractAtomItemRepository = approvalOnwardsContractAtomItemRepository;
            _configuration = configuration;
            _atomFeedGenerator = atomFeedGenerator;
            _pageNumberMutator = pageNumberMutator;
        }
       
        #region Contract Approval Notification

        public const string ContractApprovalRouteSuffix = "approvals";
        
        [Route(ContractApprovalRouteSuffix + "/{pageRef}")]
        [HttpGet]
        public ActionResult GetApprovedContractsPage(int pageRef)
        {
            pageRef = _pageNumberMutator.MutatePageNumberIn(pageRef);
            if (pageRef < 0)
            {
                return new NotFoundResult();
            }

            var result = Execute.ExecuteAndCheckForException<ArgumentException, SyndicationFeed>(() => GetApprovedContractFeed(pageRef));

            return result.Match(Left: ex => (ActionResult)NotFound(),
                Right: Ok);
        }
        
        [Route(ContractApprovalRouteSuffix)]
        [HttpGet]
        public ActionResult GetLatestApprovedContractsPage()
        {
            var response = GetApprovedContractFeed(null);

            return Ok(response);
        }

        private SyndicationFeed GetApprovedContractFeed(int? pageRef)
        {
            var resultSet = GetContractsResultSet(pageRef,_contractApprovedAtomItemRepository,ContractApprovalRouteSuffix);
            var feedId = _configuration["ApprovedContractFeedId"];
            var feed = _atomFeedGenerator.GenerateFeed(resultSet, feedId, GetFeedTitle(Notification.Approved), FeedAuthor, new ApprovedContractAtomFeedSyndicationItemCreator(MediaType));

            var response = feed;

            // if we're serving an empty head feed, set last modified to now
            response.LastUpdatedTime = feed.LastUpdatedTime != DateTimeOffset.MinValue ? feed.LastUpdatedTime : DateTimeOffset.UtcNow;
            return response;
        }
        
        #endregion

        #region Contract All Notification

        [Route("{pageRef}")]
        [HttpGet]
        public ActionResult GetAllContractsPage(int pageRef)
        {
            pageRef = _pageNumberMutator.MutatePageNumberIn(pageRef);
            if (pageRef < 0)
            {
                return NotFound();
            }

            var result = Execute.ExecuteAndCheckForException<ArgumentException, SyndicationFeed>(() => GetAllContractFeed(pageRef));

            return result.Match(Left: ex => (ActionResult)NotFound(),
                Right: Ok);
        }

        [HttpGet]
        public ActionResult GetLatestAllContractsPage()
        {
            var response = GetAllContractFeed(null);

            return Ok(response);
        }

        private SyndicationFeed GetAllContractFeed(int? pageRef)
        {
            var resultSet = GetContractsResultSet(pageRef, _allContractAtomItemRepository, string.Empty);

            var feedId = _configuration["AllContractFeedId"];

            var feed = _atomFeedGenerator.GenerateFeed(resultSet, feedId, GetFeedTitle(Notification.All), FeedAuthor, new AllContractAtomFeedSyndicationItemCreator(MediaType));

            // if we're serving an empty head feed, set last modified to now
            feed.LastUpdatedTime = feed.LastUpdatedTime != DateTimeOffset.MinValue ? feed.LastUpdatedTime : DateTimeOffset.UtcNow;
            return feed;
        }

        #endregion

        #region Contract Draft Notification

        public const string ContractDraftRouteSuffix = "draft";

        [Route(ContractDraftRouteSuffix + "/{pageRef}")]
        [HttpGet]
        public ActionResult GetDraftContractsPage(int pageRef)
        {
            pageRef = _pageNumberMutator.MutatePageNumberIn(pageRef);
            if (pageRef < 0)
            {
                return NotFound();
            }

            var result = Execute.ExecuteAndCheckForException<ArgumentException, SyndicationFeed>(() => GetDraftContractFeed(pageRef));

            return result.Match(Left: ex => (ActionResult)NotFound(),
                Right: Ok);
        }

        [Route(ContractDraftRouteSuffix)]
        [HttpGet]
        public ActionResult GetLatestDraftContractsPage()
        {
            var response = GetDraftContractFeed(null);

            return Ok(response);
        }

        private SyndicationFeed GetDraftContractFeed(int? pageRef)
        {
            var resultSet = GetContractsResultSet(pageRef, _draftContractAtomItemRepository, ContractDraftRouteSuffix);
            var feedId = _configuration["DraftContractFeedId"];
            var feed = _atomFeedGenerator.GenerateFeed(resultSet, feedId, GetFeedTitle(Notification.Draft), FeedAuthor, new DraftContractAtomFeedSyndicationItemCreator(MediaType));

            // if we're serving an empty head feed, set last modified to now
            feed.LastUpdatedTime = feed.LastUpdatedTime != DateTimeOffset.MinValue ? feed.LastUpdatedTime : DateTimeOffset.UtcNow;
            return feed;
        }

        #endregion

        #region Contract Approval Onwards Notification

        public const string ContractApprovalOnwardsRouteSuffix = "approval-onwards";

        [Route(ContractApprovalOnwardsRouteSuffix + "/{pageRef}")]
        [HttpGet]
        public ActionResult GetApprovedOnwardsContractsPage(int pageRef)
        {
            pageRef = _pageNumberMutator.MutatePageNumberIn(pageRef);
            if (pageRef < 0)
            {
                return NotFound();
            }

            var result = Execute.ExecuteAndCheckForException<ArgumentException, SyndicationFeed>(() => GetApprovedOnwardsContractFeed(pageRef));

            return result.Match(Left: ex => (ActionResult)NotFound(),
                Right: Ok);
        }

        [Route(ContractApprovalOnwardsRouteSuffix)]
        [HttpGet]
        public ActionResult GetLatestApprovedOnwardsContractsPage()
        {
            var response = GetApprovedOnwardsContractFeed(null);

            return Ok(response);
        }

        private SyndicationFeed GetApprovedOnwardsContractFeed(int? pageRef)
        {
            var resultSet = GetContractsResultSet(pageRef, _approvalOnwardsContractAtomItemRepository, ContractApprovalOnwardsRouteSuffix);
            var feedId = _configuration["ApprovalOnwardsFeedId"];
            var feed = _atomFeedGenerator.GenerateFeed(resultSet, feedId, GetFeedTitle(Notification.ApprovalOnwards), FeedAuthor, new AllContractAtomFeedSyndicationItemCreator(MediaType));

            // if we're serving an empty head feed, set last modified to now
            feed.LastUpdatedTime = feed.LastUpdatedTime != DateTimeOffset.MinValue ? feed.LastUpdatedTime : DateTimeOffset.UtcNow;
            return feed;
        }

        #endregion

        private static string GetFeedTitle(Notification notification)
        {
            Dictionary<Notification, string> feedTitleForNotificationType = new Dictionary<Notification, string>
            {
                { Notification.All, "Contract Management Contract Notifications" },
                { Notification.ApprovalOnwards, "Contract Management Approval Onwards Contract Notifications" }
            };

            return feedTitleForNotificationType.ContainsKey(notification)
                ? feedTitleForNotificationType[notification]
                : $"Contract Management {notification} Contract Notifications";
        }

        private AtomFeed.PageStorageResultSet<AtomFeedItem> GetContractsResultSet(int? requestedPageNumber, IAtomItemQueryRepository repository, string routeSuffix)
        {
            var pageStorageResultSet = new AtomFeed.PageStorageResultSet<AtomFeedItem> { PageNumber = requestedPageNumber };

            try
            {
                pageStorageResultSet.NextPageNumber = repository.GetNextPageNumber(requestedPageNumber);

                StoragePage<AtomFeedItem> storagePage = pageStorageResultSet.PageNumber == null
                    ? repository.GetEntitiesForLatestPage()
                    : repository.GetEntitiesForPage(pageStorageResultSet.PageNumber.Value);

                pageStorageResultSet.PrevPageNumber = repository.GetPreviousPageNumber(storagePage.PageNumber);
                pageStorageResultSet.MediaType = MediaType;

                pageStorageResultSet.Rows = storagePage.Rows;
                if (storagePage.Rows.Any())
                {
                    pageStorageResultSet.LatestRowUpdatedTime =
                        storagePage.Rows.OrderByDescending(e => e.CreatedDate).First().CreatedDate;
                }

                pageStorageResultSet.Host = Utils.ResultSetHostValueHelper.SchemeAndHostValue(Request, _configuration["ContractManagementServiceUrl"]);
                pageStorageResultSet.PageSize = repository.PageSize;

                pageStorageResultSet.RoutePrefix = RoutePrefix;
                pageStorageResultSet.RouteSuffix = routeSuffix;
            }
            catch (ArgumentOutOfRangeException)
            {
                throw new ArgumentException($"RequestedPageNumber: {requestedPageNumber}, not found");
            }

            return pageStorageResultSet;
        }
    }
}
