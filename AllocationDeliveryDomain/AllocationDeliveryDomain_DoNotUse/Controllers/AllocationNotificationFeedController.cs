namespace SFA.FCT.AllocationDeliveryDomain.Controllers
{
    using System.Configuration;
    using SFA.FCT.AllocationDelivery.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Atom_Feed;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.Atom;
    using SFA.FCT.CrossDomain.Integration.Common.Atom.EntryContent;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.ServiceModel.Syndication;
    using System.Web.Http;
    using System.Web.Http.Results;
    using CrossDomain.Integration.Common.Attributes;
    using CorporateSchema = CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using SFA.FCT.AllocationDeliveryDomain.Web.Api_Attributes;

    //TODO: exception filter

    //TODO: new build for this solution

    //[Authorize]
    //[SecureResource]
    [RoutePrefix(RoutePrefix)]
    [LoggingExceptionFilter]
    public class AllocationNotificationFeedController : ApiController
    {
        public const string RoutePrefix = "api/allocation-delivery/monitoring/notifications/all";

        private const string MediaType = "application/vnd.sfa.allocation-delivery.allocation-delivery-performance.1.0+atom+xml";

        private const string FeedTitle = "Allocation Delivery Monitoring Notifications";
        private const string FeedAuthor = "Allocation Delivery Service";
        private const int PageSize = 10;
        private readonly IPager<AllocationDeliveryEntry> _deliveryAllocationRepository;
        private readonly IAtomFeedGenerator<AllocationDeliveryEntry> _atomFeedGenerator;

        public AllocationNotificationFeedController(IPager<AllocationDeliveryEntry> deliveryAllocationRepository, IAtomFeedGenerator<AllocationDeliveryEntry> atomFeedGenerator)
        {
            _deliveryAllocationRepository = deliveryAllocationRepository;
            _atomFeedGenerator = atomFeedGenerator;
        }

        [Route("{pageRef}")]
        [HttpGet]
        public IHttpActionResult GetAllocationDeliveryMonitoringPage(int pageRef)
        {
            var resultSet = GetAllocationDeliveryMonitoringResultSet(pageRef);

            SyndicationFeed feed = _atomFeedGenerator.GenerateFeed(resultSet, ConfigurationManager.AppSettings["FeedId"], FeedTitle, FeedAuthor, new CreateAllocationDeliveryFeedSyndicationItem());

            if (!resultSet.Rows.Any())
                return BadRequest();

            return Ok(feed);
        }

        [Route("")]
        [HttpGet]
        public IHttpActionResult GetLatestAllocationDeliveryMonitoringPage()
        {
            var resultSet = GetAllocationDeliveryMonitoringResultSet(null);

            SyndicationFeed feed = _atomFeedGenerator.GenerateFeed(resultSet, ConfigurationManager.AppSettings["FeedId"], FeedTitle, FeedAuthor, new CreateAllocationDeliveryFeedSyndicationItem());

            // getting current page and there's no results is not a bad request by the client
            //if (!resultSet.Rows.Any())
            //    return BadRequest();

            return Ok(feed);
        }

        private PageStorageResultSet<AllocationDeliveryEntry> GetAllocationDeliveryMonitoringResultSet(int? pageRef)
        {
            var pageStorageResultSet = new PageStorageResultSet<AllocationDeliveryEntry> { PageNumber = pageRef };

            StoragePage<AllocationDeliveryEntry> storagePage = pageStorageResultSet.PageNumber == null ?
                _deliveryAllocationRepository.GetEntitiesForLatestPage() :
                _deliveryAllocationRepository.GetEntitiesForPage(pageStorageResultSet.PageNumber.Value);

            pageStorageResultSet.MediaType = MediaType;

            //TODO: check accept header and return 406 	Not Acceptable if no match
            //Request.Headers.Accept.First(h => h.MediaType.ToUpper().Contains("ATOM")).MediaType;

            pageStorageResultSet.Rows = storagePage.Rows;
            pageStorageResultSet.Host = ConfigurationManager.AppSettings["AllocationDeliveryServiceUrl"];
            pageStorageResultSet.PageSize = PageSize;
            pageStorageResultSet.NextPageNumber = GetNextPageNumber(pageRef);
            pageStorageResultSet.PrevPageNumber = GetPrevPageNumber(pageRef, storagePage.PageNumber);
            //TODO: prefix/suffix
            pageStorageResultSet.RoutePrefix = RoutePrefix;
            //pageStorageResultSet.RouteSuffix = ContractApprovalRouteSuffix;

            return pageStorageResultSet;
        }

        private int? GetNextPageNumber(int? pageRef)
        {
            int? nextPageNumber = null;

            // if we have a page number but no further pages then the next page must be the latest
            if (pageRef.HasValue)
            {
                int nextPageTestNumber = pageRef.Value + 1;
                if (_deliveryAllocationRepository.GetEntitiesForPage(nextPageTestNumber).Rows.Any())
                {
                    nextPageNumber = nextPageTestNumber;
                }
            }

            return nextPageNumber;
        }

        private int? GetPrevPageNumber(int? pageRef, int pageNumberOnceCommitted)
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
