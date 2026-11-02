namespace SFA.FCT.ContractManagementService.Controllers.FundingConfigService
{
    using FCS.Worker.Common;
    using Microsoft.AspNetCore.Mvc;
    using System.Linq;
    using System.ServiceModel.Syndication;
    using System.Threading.Tasks;
    using global::ContractManagementService.AtomFeed;
    using global::ContractManagementService.AtomFeed.EntryContent;
    using global::ContractManagementService.Repositories;

    public abstract class AtomFeedController<T, TEntryContent> : ControllerBase where TEntryContent : IEntryContent<T>, new()
    {
        private const int PageSize = 10;
        private readonly IPagedStorageQueryRepository<T> _repository;
        private readonly SFA.FCT.ContractManagementService.AtomFeed.IAtomFeedGenerator<T> _atomFeedGenerator;
        private readonly IFcsConfiguration _configuration;
        private readonly string _routePrefix;
        private readonly string _routeSuffix;

        protected AtomFeedController(
            IPagedStorageQueryRepository<T> repository,
            SFA.FCT.ContractManagementService.AtomFeed.IAtomFeedGenerator<T> atomFeedGenerator,
            string routePrefix,
            string routeSuffix, IFcsConfiguration configuration)
        {
            _repository = repository;
            _atomFeedGenerator = atomFeedGenerator;
            _routePrefix = routePrefix;
            _routeSuffix = routeSuffix;
            _configuration = configuration;
        }

        protected abstract string FeedTitle { get; }

        protected abstract string FeedAuthor { get; }

        public virtual async Task<ActionResult> GetPage(int pageRef)
        {
            AtomFeed.PageStorageResultSet<T> pageStorageResultSet = await GetEntitiesResultSet(pageRef);

            var syndicationItemCreator = new SyndicationItemCreator<T, TEntryContent>();
            SyndicationFeed feed = _atomFeedGenerator.GenerateFeed(pageStorageResultSet, null, FeedTitle, FeedAuthor, syndicationItemCreator, normalizePageNumber: false);

            if (!pageStorageResultSet.Rows.Any())
            {
                return BadRequest();
            }

            return Ok(feed);
        }

        public virtual async Task<ActionResult> GetLatestPage()
        {
            var pageStorageResultSet = await GetEntitiesResultSet(null);

            var syndicationItemCreator = new SyndicationItemCreator<T, TEntryContent>();
            SyndicationFeed feed = _atomFeedGenerator.GenerateFeed(pageStorageResultSet, null, FeedTitle, FeedAuthor, syndicationItemCreator, normalizePageNumber: false);

            return Ok(feed);
        }

        protected async Task<AtomFeed.PageStorageResultSet<T>> GetEntitiesResultSet(int? pageRef)
        {
            var pageStorageResultSet = new AtomFeed.PageStorageResultSet<T>()
            {
                PageNumber = pageRef
            };

            var storagePageTask = pageStorageResultSet.PageNumber == null ?
                _repository.GetEntitiesForLatestPage() :
                _repository.GetEntitiesForPage(pageStorageResultSet.PageNumber.Value);

            var storagePage = await storagePageTask;

            if (Request != null) // necessary for testing
            {
                pageStorageResultSet.MediaType =
                    Request.Headers["Accept"].First(h => h.ToUpper().Contains("ATOM"));
                pageStorageResultSet.Host = GetHost();
            }

            pageStorageResultSet.Rows = storagePage.Rows;
            pageStorageResultSet.PageSize = PageSize;
            pageStorageResultSet.NextPageNumber = GetNextPageNumber(pageRef);
            pageStorageResultSet.PrevPageNumber = GetPrevPageNumber(pageRef, storagePage.PageNumber);
            pageStorageResultSet.RoutePrefix = _routePrefix;
            pageStorageResultSet.RouteSuffix = _routeSuffix;

            return pageStorageResultSet;
        }

        private string GetHost()
        {
            var host = Utils.ResultSetHostValueHelper.SchemeAndHostValue(Request, _configuration["FundingPolicyUrl"]);
            return host;
        }

        private int? GetNextPageNumber(int? pageRef)
        {
            int? nextPageNumber = null;

            // if we have a page number but no further pages then the next page must be the latest
            if (pageRef.HasValue)
            {
                int nextPageTestNumber = pageRef.Value + 1;
                if (_repository.GetEntitiesForPage(nextPageTestNumber).Result.Rows.Any())
                {
                    nextPageNumber = nextPageTestNumber;
                }
            }

            return nextPageNumber;
        }

        private static int? GetPrevPageNumber(int? pageRef, int pageNumberOnceCommitted)
        {
            int? prevPageNumber = null;
            if (pageRef.HasValue && pageRef.Value > 1)
            {
                prevPageNumber = pageRef.Value - 1;
            }
            else if (pageNumberOnceCommitted > 1)
            {
                prevPageNumber = pageNumberOnceCommitted - 1;
            }

            return prevPageNumber;
        }
    }
}