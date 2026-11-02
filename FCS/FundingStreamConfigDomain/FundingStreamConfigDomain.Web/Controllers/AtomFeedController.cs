namespace SFA.FCT.FundingPolicyDomain.Controllers
{
    using System.Configuration;
    using System.Linq;
    using System.ServiceModel.Syndication;
    using System.Web.Http;
    using CrossDomain.Integration.Common.Atom;
    using CrossDomain.Integration.Common.Atom.SyndicationItemCreator;
    using CrossDomain.Integration.Common.PagedStorage;

    public abstract class AtomFeedController<T, TEntryContent> : ApiController where TEntryContent : IEntryContent<T>, new()
    {
        private const int PageSize = 10;
        private readonly IPagedStorageRepository<T> _repository;
        private readonly IAtomFeedGenerator<T> _atomFeedGenerator;
        private readonly string _routePrefix;
        private readonly string _routeSuffix;

        protected AtomFeedController(
            IPagedStorageRepository<T> repository,
            IAtomFeedGenerator<T> atomFeedGenerator,
            string routePrefix,
            string routeSuffix)
        {
            _repository = repository;
            _atomFeedGenerator = atomFeedGenerator;
            _routePrefix = routePrefix;
            _routeSuffix = routeSuffix;
        }

        protected abstract string FeedTitle { get; }

        protected abstract string FeedAuthor { get; }

        public virtual IHttpActionResult GetPage(int pageRef)
        {
            PageStorageResultSet<T> pageStorageResultSet = GetEntitiesResultSet(pageRef);

            SyndicationFeed feed = _atomFeedGenerator.GenerateFeed(pageStorageResultSet, null, FeedTitle, FeedAuthor, new SyndicationItemCreator<T, TEntryContent>());

            if (!pageStorageResultSet.Rows.Any())
            {
                return BadRequest();
            }

            return Ok(feed);
        }

        public virtual IHttpActionResult GetLatestPage()
        {
            PageStorageResultSet<T> pageStorageResultSet = GetEntitiesResultSet(null);

            SyndicationFeed feed = _atomFeedGenerator.GenerateFeed(pageStorageResultSet, null, FeedTitle, FeedAuthor, new SyndicationItemCreator<T, TEntryContent>());

            return Ok(feed);
        }

        protected PageStorageResultSet<T> GetEntitiesResultSet(int? pageRef)
        {
            PageStorageResultSet<T> pageStorageResultSet = new PageStorageResultSet<T>()
            {
                PageNumber = pageRef
            };

            StoragePage<T> storagePage = pageStorageResultSet.PageNumber == null ?
                _repository.GetEntitiesForLatestPage() :
                _repository.GetEntitiesForPage(pageStorageResultSet.PageNumber.Value);

            if (Request != null) // necessary for testing
            {
                pageStorageResultSet.MediaType =
                    Request.Headers.Accept.First(h => h.MediaType.ToUpper().Contains("ATOM")).MediaType;
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
            var host = ConfigurationManager.AppSettings["FundingPolicyUrl"];
            return host;
        }

        private int? GetNextPageNumber(int? pageRef)
        {
            int? nextPageNumber = null;

            // if we have a page number but no further pages then the next page must be the latest
            if (pageRef.HasValue)
            {
                int nextPageTestNumber = pageRef.Value + 1;
                if (_repository.GetEntitiesForPage(nextPageTestNumber).Rows.Any())
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