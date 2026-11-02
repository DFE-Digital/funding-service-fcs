namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories.Atom
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using CrossDomain.Integration.Common.PagedStorage;
    using Dapper;
    using Models;

    public class AtomFeedItemQueryRepository : IAtomFeedItemQueryRepository
    {
        private readonly SqlConnection _connection;

        public AtomFeedItemQueryRepository(SqlConnection connection)
        {
            _connection = connection;
        }

        public int PageSize => 10;        

        /// <summary>
        /// Returns the next page number if the page is in range, if the next page is the last page then it 
        /// will return null. This will throw ArgumentOutOfRangeException if out of range.
        /// </summary>
        /// <param name="requestedPage">This is zero based</param>
        /// <returns>Returns the next page number if the page is in range</returns>
        public int? GetNextPageNumber(int? requestedPage)
        {
            int? nextPage = null;
            if (requestedPage.HasValue)
            {
                nextPage = requestedPage + 1;

                int totalItems = GetTotalRowsCount();
                int nextPageStart = nextPage.Value * PageSize;

                if (IsRequestedPageWithinRange(requestedPage, totalItems, nextPageStart))
                {
                    // we either have a valid next page or the next page is the last page
                    int remainingItems = totalItems - nextPageStart;
                    if (remainingItems <= PageSize)
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

        public StoragePage<AtomFeedItem> GetEntitiesForPage(int page)
        {
            int skip = page * PageSize;

            IList<AtomFeedItem> atomFeedItems = GetAtomFeedItems(skip);

            return new StoragePage<AtomFeedItem>()
            {
                PageNumber = page,
                Rows = atomFeedItems
            };
        }

        public StoragePage<AtomFeedItem> GetEntitiesForLatestPage()
        {
            int pageCount = GetPageCount();

            int skip = pageCount * PageSize;

            IList<AtomFeedItem> atomFeedItems = GetAtomFeedItems(skip);

            return new StoragePage<AtomFeedItem>()
            {
                PageNumber = pageCount,
                Rows = atomFeedItems
            };
        }

        private bool IsRequestedPageWithinRange(int? requestedPage, int totalItems, int nextPageStart)
        {
            // because we 'mutate' the request page number (see the controller) a requestedPage of 1 becomes 0
            return requestedPage >= 0 && nextPageStart < totalItems;
        }

        private int GetPageCount()
        {
            var totalEntries = GetTotalRowsCount();
            int pageCount = (int)Math.Floor((double)(totalEntries / (double)PageSize));

            if (totalEntries > 0)
            {
                // if don't have a remainder then we need to make the reduce the pageCount
                int remainder = totalEntries % PageSize;
                if (remainder == 0)
                {
                    pageCount--;
                }
            }

            return pageCount;
        }

        private int GetTotalRowsCount()
        {
            const string sql = @"SELECT count(1) FROM [PerformanceManagement].[AtomFeedItem]";

            return _connection.ExecuteScalar<int>(sql);

        }

        private IList<AtomFeedItem> GetAtomFeedItems(int skip)
        {           
            return _connection.Query<AtomFeedItem>("dbo.sp_PerfMgmtDomain_GetAtomFeedItems @skip,@pageSize", new { @skip = skip, @pageSize = PageSize}).ToList();
        }
    }
}
