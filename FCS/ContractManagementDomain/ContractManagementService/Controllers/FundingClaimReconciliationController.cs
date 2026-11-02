namespace SFA.FCT.ContractManagementService.Controllers
{
    using System;
    using Common;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Messages.Commands;
    using Framework.Logging.Interfaces;
    using NSB;
    using CrossDomain.Integration.Common.Atom;
    using PerformanceManagementDomain.DataStore.Models;
    using CrossDomain.Integration.Common.PagedStorage;
    using System.Linq;
    using System.ServiceModel.Syndication;
    using System.Text;
    using AtomFeed;
    using FCS.Worker.Common;
    using Microsoft.AspNetCore.Mvc;
    using PerformanceManagementDomain.DataStore.Repositories.Atom;

    [ApiController]
    [Route(RoutePrefix)]
    public class FundingClaimReconciliationController : ControllerBase
    {
        private readonly ILogger _logger;
        private readonly SFA.FCT.ContractManagementService.AtomFeed.IAtomFeedGenerator<AtomFeedItem> _atomFeedGenerator;
        private readonly IAtomFeedItemQueryRepository _atomFeedItemQueryRepository;
        private readonly IFcsConfiguration _configuration;

        private readonly TimeSpan _cacheMaxAge = new TimeSpan(365, 0, 0, 0);
        private const string MediaType = "application/vnd.sfa.fundingclaimreconciliation.v1+atom+xml";
        private const string FeedTitle = "Funding Claim Reconciliation Notifications";
        private const string FeedAuthor = "Funding Claim Reconciliation Service";
        private const int PageSize = 10;
        public const string RoutePrefix = "api/performance-management/funding-claim-reconciliations";
        public const string AtomRoutePrefix = "api/performance-management/funding-claim-reconciliations/notifications";

        public FundingClaimReconciliationController(
            ILogger logger,
            SFA.FCT.ContractManagementService.AtomFeed.IAtomFeedGenerator<AtomFeedItem> atomFeedGenerator,
            IAtomFeedItemQueryRepository atomFeedItemQueryRepository,
            IFcsConfiguration configuration)
        {
            _logger = logger;
            _atomFeedGenerator = atomFeedGenerator;
            _atomFeedItemQueryRepository = atomFeedItemQueryRepository;
            _configuration = configuration;
        }

        [HttpGet]
        [Route("")]
        public ActionResult Get()
        {
            return Accepted();
        }

        [HttpPost]
        [Route("ConfirmPublish")]
        public ActionResult ConfirmPublish(ClaimInformation claimInformation)
        {
            string xml;
            using (System.IO.StreamReader reader = new System.IO.StreamReader(Request.Body, Encoding.UTF8))
            {
                xml = reader.ReadToEndAsync().Result;
            }
            _logger.LogInformation(ContractManagementLoggingEvents.InitiatePublishOfFundingClaimReconciliationReceived, $"Received a POST call to initiate publish for {claimInformation}");

            ServiceBus.Bus.Send(
                    FctEndpoint.GenerateEndpointName("PerformanceManagementDomain.ReconciliationPublication"),
                    new InitiatePublishOfFundingClaimReconciliationCommand(claimInformation.Id, claimInformation.FCRName));

            _logger.LogInformation(ContractManagementLoggingEvents.InitiatePublishOfFundingClaimReconciliationCommandSent, $"Sent a InitiatePublishOfFundingClaimReconciliationCommand {claimInformation}");
            return Accepted();
        }

        [Route("notifications")]
        [HttpGet]
        public ActionResult GetLatestFundingClaimReconciliationPage()
        {
            // note: if the client requests the head page and there's no results, we just return an empty feed

            var response = GetFundingClaimReconciliationFeed(null);

          //  response.Headers.CacheControl = new CacheControlHeaderValue { NoCache = true };

            return Ok(response);
        }

        [Route("notifications/{pageRef}")]
        [HttpGet]
        public ActionResult GetFundingClaimReconciliationPage(int pageRef)
        {
            pageRef = AtomPageNumberNormalizer.FromUrlPageNumber(pageRef);
            if (pageRef < 0)
            {
                return NotFound();
            }

            var response = GetFundingClaimReconciliationFeed(pageRef);

           // response.Headers.CacheControl = new CacheControlHeaderValue { MaxAge = _cacheMaxAge, Private = true };
            return Ok(response);
        }

        private SyndicationFeed GetFundingClaimReconciliationFeed(int? pageRef)
        {
            var resultSet = GetContractsResultSet(pageRef, _atomFeedItemQueryRepository, "notifications");

            var feedId = _configuration["FundingClaimReconciliationFeedId"];

            var feed = _atomFeedGenerator.GenerateFeed(resultSet, feedId, FeedTitle, FeedAuthor, new FundingClaimReconciliationFeedSyndicationItemCreator(MediaType));

            // if we're serving an empty head feed, set last modified to now
            feed.LastUpdatedTime = feed.LastUpdatedTime != DateTimeOffset.MinValue ? feed.LastUpdatedTime : DateTimeOffset.UtcNow;
            return feed;
        }

        private AtomFeed.PageStorageResultSet<AtomFeedItem> GetContractsResultSet(int? requestedPageNumber, IAtomFeedItemQueryRepository repository, string routeSuffix)
        {
            var pageStorageResultSet = new AtomFeed.PageStorageResultSet<AtomFeedItem> { PageNumber = requestedPageNumber };

            try
            {
                pageStorageResultSet.NextPageNumber = repository.GetNextPageNumber(requestedPageNumber);

                // ReSharper disable once SuggestVarOrType_Elsewhere
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
                throw new ArgumentException($"requestedPageNumber: {requestedPageNumber}, not valid");
            }

            return pageStorageResultSet;
        }
    }
}
