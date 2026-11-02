namespace PaymentGenerationDomain.Integration.DataStore.Repositories
{
    using System;
    using System.Data.Entity.Infrastructure;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Threading.Tasks;
    using Model;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration;
    using Dapper;
    using SFA.FCS.Worker.Common;
    using ConnectionInfo = SFA.FCT.CrossDomain.Integration.Entities.Data.ConnectionInfo;

    public enum PaymentBatchFeedItemAddResult
    {
        Added,
        AlreadyPresent
    }

    public class PaymentBatchFeedItemRepository : IPaymentBatchFeedItemRepository, IPaymentBatchFeedItemCommandRepository, IPaymentBatchFeedItemQueryRepository
    {
        private readonly IFcsConfiguration _configuration;

        public PaymentBatchFeedItemRepository(IFcsConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<int?> GetNextPageNumber(int? requestedPage, int pageSize)
        {
            int? nextPage = null;
            if (requestedPage.HasValue)
            {
                nextPage = requestedPage + 1;

                int totalItems = await GetTotalRowCount().ConfigureAwait(continueOnCapturedContext: false);

                int nextPageStart = nextPage.Value * pageSize;

                if (IsRequestedPageWithinRange(requestedPage, totalItems, nextPageStart))
                {
                    // we either have a valid next page or the next page is the last page
                    int remainingItems = totalItems - nextPageStart;
                    if (remainingItems <= pageSize)
                    {
                        // the next page is actually the last page
                        nextPage = null;
                    }
                }
                else
                {
                    // we are out of range
                    throw new ArgumentOutOfRangeException();
                }
            }

            return nextPage;
        }

        public int? GetPreviousPageNumber(int page)
        {
            return (--page < 0) ? (int?)null : page;
        }
        public async Task<StoragePage<PaymentBatchFeedItem>> GetEntitiesForPage(int pageNumber, int pageSize)
        {
            int skip = pageNumber * pageSize;           

            var pageOfItems = await Connection.QueryAsync<PaymentBatchFeedItem>("dbo.sp_PayGenDomain_GetEntitiesForPage @skip,@pageSize", new { @skip = skip, @pageSize = pageSize })
                .ConfigureAwait(continueOnCapturedContext: false);

            return new StoragePage<PaymentBatchFeedItem>
            {
                PageNumber = pageNumber,
                Rows = pageOfItems.ToList()
            };
        }

        public async Task<StoragePage<PaymentBatchFeedItem>> GetEntitiesForLatestPage(int pageSize)
        {          

            var rowCountInfo = await GetRowCountInfo(pageSize).ConfigureAwait(continueOnCapturedContext: false);

            int skip = rowCountInfo.PageCount * pageSize;
            int rowsInLatestPage = rowCountInfo.TotalRows - skip;

            var pageOfItems = await Connection.QueryAsync<PaymentBatchFeedItem>("dbo.sp_PayGenDomain_GetEntitiesForLatestPage @rowsInLatestPage", new { @rowsInLatestPage = rowsInLatestPage })
                .ConfigureAwait(continueOnCapturedContext: false);

            return new StoragePage<PaymentBatchFeedItem>()
            {
                PageNumber = rowCountInfo.PageCount,
                Rows = pageOfItems.OrderBy(e => e.Id).ToList() // turn the latest back to ascending
            };
        }


        public async Task<PaymentBatchFeedItem> GetItemById(int id)
        {            
            return await Connection.QuerySingleOrDefaultAsync<PaymentBatchFeedItem>("sp_PayGenDomain_GetItemById @id", new { @id = id })
                .ConfigureAwait(continueOnCapturedContext: false);
        }

        public async Task<bool> Any()
        {
            int totalItems = await GetTotalRowCount().ConfigureAwait(continueOnCapturedContext: false);
            return totalItems > 0;
        }

        public async Task<PaymentBatchFeedItemAddResult> AddItem(PaymentBatchFeedItem paymentBatchFeedItem, ConnectionInfo connectionInfo)
        {
            const int violationOfUniqueIndex = 2601;
            try
            {
                using (var context = new PaymentGenerationDbContext(connectionInfo.Connection))
                {
                    if (connectionInfo.Transaction != null)
                    {
                        context.Database.UseTransaction(connectionInfo.Transaction);
                    }

                    context.PaymentBatchFeedItems.Add(paymentBatchFeedItem);

                    await context.SaveChangesAsync().ConfigureAwait(continueOnCapturedContext: false); ;

                    return PaymentBatchFeedItemAddResult.Added;
                }
            }
            catch (DbUpdateException ex) when (ex.InnerException?.InnerException is SqlException exception && exception.Number == violationOfUniqueIndex)
            {
                return PaymentBatchFeedItemAddResult.AlreadyPresent;
            }
        }

        public async Task<PaymentPeriod> GetPaymentPeriod(int paymentBatchFeedItemId)
        {
            PaymentBatchFeedItem paymentBatchFeedItem = await GetItemById(paymentBatchFeedItemId).ConfigureAwait(continueOnCapturedContext: false);

            string paymentBatchXml = paymentBatchFeedItem.GetPaymentBatchXml();

            return paymentBatchXml.DeserializeXml<PaymentPeriod>();
        }

        private SqlConnection Connection => new SqlConnection(_configuration["ConnectionStrings:PaymentGenerationDbContext"]);

        private static bool IsRequestedPageWithinRange(int? requestedPage, int totalItems, int nextPageStart)
        {
            // requestedPage is zero based (it was altered by the caller)
            return requestedPage >= 0 && nextPageStart < totalItems;
        }

        private async Task<int> GetTotalRowCount()
        {
            return (int)await Connection
                .ExecuteScalarAsync("SELECT COUNT(1) FROM [PaymentGeneration].[PaymentBatchFeedItem]")
                .ConfigureAwait(continueOnCapturedContext: false);
        }

        private async Task<RowCountInfo> GetRowCountInfo(int pageSize)
        {
            var totalEntries = await GetTotalRowCount().ConfigureAwait(continueOnCapturedContext: false);

            int pageCount = (int)Math.Floor(totalEntries / (double)pageSize);

            if (totalEntries > 0)
            {
                // if don't have a remainder then we need to make the reduce the pageCount
                int remainder = totalEntries % pageSize;
                if (remainder == 0)
                {
                    pageCount--;
                }
            }

            return new RowCountInfo(totalEntries, pageCount);
        }

        private class RowCountInfo
        {
            public RowCountInfo(int totalRows, int pageCount)
            {
                TotalRows = totalRows;
                PageCount = pageCount;
            }

            public int TotalRows { get; }

            public int PageCount { get; }
        }
    }
}
