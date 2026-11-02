namespace SFA.FCT.ContractManagementService.Controllers
{
    using AtomFeed;
    using FCS.Worker.Common;
    using Microsoft.AspNetCore.Authorization;
    using Microsoft.AspNetCore.Mvc;
    using System;
    using System.Linq;
    using System.ServiceModel.Syndication;
    using global::ContractManagementService.DTOs;
    using global::ContractManagementService.Repositories;
    using Microsoft.Net.Http.Headers;

    [Authorize]
    [Route(RoutePrefix)]
    [ApiController]
    public class AllocationNotificationFeedController : ControllerBase
    {
        public const string RoutePrefix = "api/allocation-delivery/monitoring/notifications/all";

        private const string MediaType = "application/vnd.sfa.allocation-delivery.allocation-delivery-performance.v1+atom+xml";

        private const string FeedTitle = "Allocation Delivery Monitoring Notifications";
        private const string FeedAuthor = "Allocation Delivery Service";
        private const int PageSize = 10;
        private readonly IAllocationDeliveryEntryQueryRepository _repository;
        private readonly SFA.FCT.ContractManagementService.AtomFeed.IAtomFeedGenerator<AllocationDeliveryEntry> _atomFeedGenerator;
        private readonly CrossDomain.Integration.Common.Atom.IPageNumberMutator _pageNumberMutator;
        private readonly IFcsConfiguration _configuration;

        private TimeSpan _cacheMaxAge = new TimeSpan(365, 0, 0, 0);

        public AllocationNotificationFeedController(
            SFA.FCT.ContractManagementService.AtomFeed.IAtomFeedGenerator<AllocationDeliveryEntry> atomFeedGenerator,
            CrossDomain.Integration.Common.Atom.IPageNumberMutator pageNumberMutator, IAllocationDeliveryEntryQueryRepository repository, IFcsConfiguration configuration)
        {
            _atomFeedGenerator = atomFeedGenerator;
            _pageNumberMutator = pageNumberMutator;
            _repository = repository;
            _configuration = configuration;
        }

        [Route("{pageRef}")]
        [HttpGet]
        public ActionResult GetAllocationDeliveryMonitoringPage(int pageRef)
        {
            pageRef = _pageNumberMutator.MutatePageNumberIn(pageRef);
            if (pageRef < 0)
            {
                return new NotFoundResult();
            }

            try
            {
                var response = GetAllocationDeliveryFeed(pageRef);
                return Ok(response);
            }
            catch (ArgumentOutOfRangeException)
            {
                return new NotFoundResult();
            }
        }

        [Route("")]
        [HttpGet]
        public ActionResult GetLatestAllocationDeliveryMonitoringPage()
        {
            // note: if the client requests the head page and there's no results, we just return an empty feed

            var response = GetAllocationDeliveryFeed(null);

            return Ok(response);
        }

        private SyndicationFeed GetAllocationDeliveryFeed(int? pageRef)
        {
            var resultSet = GetAllocationDeliveryMonitoringResultSet(pageRef);
            var feed = _atomFeedGenerator.GenerateFeed(resultSet, _configuration["AllocationDeliveryFeedId"], FeedTitle, FeedAuthor, new AllocationDeliveryFeedSyndicationItemCreator());

            SyndicationFeed response = feed;
            if (resultSet.NextPageNumber.HasValue)
            {
                Response.Headers[HeaderNames.CacheControl] = $"public,max-age={_cacheMaxAge.TotalSeconds}";
            }
            else
            {
                Response.Headers[HeaderNames.CacheControl] = "no-store,no-cache";
            }
            response.LastUpdatedTime = feed.LastUpdatedTime != DateTimeOffset.MinValue ? feed.LastUpdatedTime : DateTimeOffset.UtcNow;
            
            return response;
        }

        private PageStorageResultSet<AllocationDeliveryEntry> GetAllocationDeliveryMonitoringResultSet(int? requestedPageNumber)
        {
            var pageStorageResultSet =
                new AtomFeed.PageStorageResultSet<AllocationDeliveryEntry>
                {
                    PageNumber = requestedPageNumber,
                    NextPageNumber = _repository.GetNextPageNumber(requestedPageNumber)
                };


            var storagePage = pageStorageResultSet.PageNumber == null ?
                _repository.GetEntitiesForLatestPage() :
                _repository.GetEntitiesForPage(pageStorageResultSet.PageNumber.Value);

            pageStorageResultSet.PrevPageNumber = _repository.GetPreviousPageNumber(storagePage.PageNumber);

            //pageStorageResultSet.NumberOfItems = _deliveryAllocationRepository.NumberOfEntities;

            pageStorageResultSet.MediaType = MediaType;

            pageStorageResultSet.Rows = storagePage.Rows;
            if (storagePage.Rows.Any())
                pageStorageResultSet.LatestRowUpdatedTime = storagePage.Rows.OrderByDescending(e => e.CreatedDate).First().CreatedDate;

            pageStorageResultSet.Host = Utils.ResultSetHostValueHelper.SchemeAndHostValue(this.Request, _configuration["ContractManagementServiceUrl"]);
            pageStorageResultSet.PageSize = PageSize;

            //TODO: prefix/suffix
            pageStorageResultSet.RoutePrefix = RoutePrefix;
            //pageStorageResultSet.RouteSuffix = ContractApprovalRouteSuffix;

            return pageStorageResultSet;
        }
    }
}
