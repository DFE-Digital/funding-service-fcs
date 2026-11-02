namespace SFA.FCT.ContractManagementService.Controllers.PaymentRequestAtomFeed
{
    using FCS.Worker.Common;
    using Microsoft.AspNetCore.Authorization;
    using Microsoft.AspNetCore.Mvc;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using PaymentGenerationDomain.Integration.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Common.Atom;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using System;
    using System.Linq;
    using System.ServiceModel.Syndication;
    using System.Threading.Tasks;

    [Authorize]
    [Route(RoutePrefix)]
    public class PaymentRequestController : ControllerBase
    {
        public const string RoutePrefix = "api/AllocationDelivery/payment-requests/notifications";

        private const string MediaType = "application/vnd.sfa.paymentrequests.v1+atom+xml";
        private const string FeedTitle = "Payment Requests Notifications";
        private const string FeedAuthor = "<author><name>Payment Requests Service</name></author>";
        private const int PageSize = 2;

        private readonly IPaymentBatchFeedItemRepository _paymentBatchFeedItemRepository;
        private readonly SFA.FCT.ContractManagementService.AtomFeed.IAtomFeedGenerator<PaymentBatchFeedItem> _atomFeedGenerator;
        private readonly IFcsConfiguration _configuration;

        public PaymentRequestController(
            IPaymentBatchFeedItemRepository paymentBatchFeedItemRepository,
            SFA.FCT.ContractManagementService.AtomFeed.IAtomFeedGenerator<PaymentBatchFeedItem> atomFeedGenerator, IFcsConfiguration configuration)
        {
            _paymentBatchFeedItemRepository = paymentBatchFeedItemRepository;
            _atomFeedGenerator = atomFeedGenerator;
            _configuration = configuration;
        }

        [Route("{pageRef}")]
        [HttpGet]
        public async Task<ActionResult> GetPaymentRequestPage(int pageRef)
        {
            int pageNumber = AtomPageNumberNormalizer.FromUrlPageNumber(pageRef);
            if (pageNumber < 0)
            {
                return NotFound();
            }

            var response = await GetPaymentRequestFeed(pageNumber);

            return Ok(response);
        }

        [HttpGet]
        public async Task<ActionResult> GetLatestPaymentRequestPage()
        {
            var response = await GetPaymentRequestFeed(null);

            return Ok(response);
        }

        private async Task<SyndicationFeed> GetPaymentRequestFeed(int? pageNumber)
        {
            AtomFeed.PageStorageResultSet<PaymentBatchFeedItem> resultSet = await GetContractsResultSet(pageNumber);
            var feedId = _configuration["PaymentRequestFeedId"];
            var feed = _atomFeedGenerator.GenerateFeed(resultSet, feedId, FeedTitle, FeedAuthor, new PaymentRequestSyndicationItemCreator());

            var response = feed;

            // if we're serving an empty head feed, set last modified to now
            response.LastUpdatedTime = feed.LastUpdatedTime != DateTimeOffset.MinValue ? feed.LastUpdatedTime : DateTimeOffset.UtcNow;
            return response;
        }

        private async Task<AtomFeed.PageStorageResultSet<PaymentBatchFeedItem>> GetContractsResultSet(int? requestedPageNumber)
        {
            var pageStorageResultSet = new AtomFeed.PageStorageResultSet<PaymentBatchFeedItem> { PageNumber = requestedPageNumber };

            try
            {
                pageStorageResultSet.NextPageNumber = await _paymentBatchFeedItemRepository.GetNextPageNumber(requestedPage: requestedPageNumber, pageSize: PageSize);

                StoragePage<PaymentBatchFeedItem> storagePage = pageStorageResultSet.PageNumber == null
                    ? await _paymentBatchFeedItemRepository.GetEntitiesForLatestPage(PageSize)
                    : await _paymentBatchFeedItemRepository.GetEntitiesForPage(pageNumber: pageStorageResultSet.PageNumber.Value, pageSize: PageSize);

                pageStorageResultSet.PrevPageNumber = _paymentBatchFeedItemRepository.GetPreviousPageNumber(storagePage.PageNumber);
                pageStorageResultSet.MediaType = MediaType;

                pageStorageResultSet.Rows = storagePage.Rows;
                if (storagePage.Rows.Any())
                {
                    pageStorageResultSet.LatestRowUpdatedTime =
                        storagePage.Rows.OrderByDescending(e => e.CreatedDate).First().CreatedDate;
                }

                pageStorageResultSet.Host = Utils.ResultSetHostValueHelper.SchemeAndHostValue(this.Request, _configuration["ContractManagementServiceUrl"]);
                pageStorageResultSet.PageSize = PageSize;

                pageStorageResultSet.RoutePrefix = RoutePrefix;
            }
            catch (ArgumentOutOfRangeException)
            {
                throw new ArgumentException($"Not valid requestedPageNumber: {requestedPageNumber}");
            }

            return pageStorageResultSet;
        }
    }
}