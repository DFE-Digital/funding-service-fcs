namespace ContractManagement.DataStore.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using Model;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;

    public abstract class AtomItemQueryRepository : IAtomItemQueryRepository
    {
        protected readonly SqlConnection _sqlConnection;

        protected AtomItemQueryRepository(SqlConnection connection)
        {
            _sqlConnection = connection;
        }

        protected abstract AtomItemType[] AtomItemTypes { get; }

        public int PageSize { get; } = 10;

        private IEnumerable<int> ContractTypes => AtomItemTypes.Select(t => (int)t).ToList();

        /// <summary>
        /// Returns the next page number if the page is in range, if the next page is the last page then it 
        /// will return null. This will throw ArgumentOutOfRangeException if out of range
        /// </summary>
        /// <param name="requestedPage"></param>
        /// <returns>Returns the next page number if the page is in range</returns>
        public int? GetNextPageNumber(int? requestedPage)
        {
            int? nextPage = null;
            if (requestedPage.HasValue)
            {
                nextPage = requestedPage + 1;

                int totalItems = GetCountOfRows();
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

        public virtual StoragePage<AtomFeedItem> GetEntitiesForLatestPage()
        {
            return GetLatestPage();
        }

        protected StoragePage<AtomFeedItem> GetLatestPage()
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

        public AtomFeedItem GetItemById(int id)
        {
            throw new NotImplementedException();
        }

        public bool Any()
        {
            return GetCountOfRows() > 0;
        }

        private bool IsRequestedPageWithinRange(int? requestedPage, int totalItems, int nextPageStart)
        {
            // because we 'mutate' the request page number (see the controller) a requestedPage of 1 becomes 0
            return requestedPage >= 0 && nextPageStart < totalItems;
        }

        private int GetCountOfRows()
        {
            const string sql = @"SELECT 
                   count(1)
                AS [DuplicateIdentifier]
                FROM[ContractManagement].[AtomFeedItem] a
                WHERE a.[ItemType]
                IN @contractTypes ";

            return _sqlConnection.ExecuteScalar<int>(sql, new {@contractTypes = ContractTypes});
        }

        protected Guid? GetLatestIdentifier()
        {
            string sql = $@"DECLARE @maxId INT

                            SELECT  @maxId = MAX(id) FROM[ContractManagement].[AtomFeedItem] a
                            WHERE   a.[ItemType]
                            IN      @contractTypes

                            IF @maxId IS NULL
                                SELECT  @maxId 
                            ELSE
                                SELECT  [Identifier]
                                FROM    [ContractManagement].[AtomFeedItem]
                                WHERE   [Id] = @maxId ";

            return _sqlConnection.ExecuteScalar<Guid?>(sql, new { @contractTypes = ContractTypes });
        }

        private IList<AtomFeedItem> GetAtomFeedItems(int skip)
        {
            string sql = $@"SELECT 
                a.[Id] AS[Id], 
                a.[Identifier] AS[Identifier], 
                a.[ItemType] AS[ItemType], 
                a.[BusinessKey] AS[BusinessKey], 
                a.[AtomFeedItemXml] AS[AtomFeedItemXml], 
                a.[AtomFeedItemBytes] AS[AtomFeedItemBytes], 
                a.[CreatedDate] AS[CreatedDate], 
                a.[DuplicateIdentifier]
            AS [DuplicateIdentifier]
            FROM[ContractManagement].[AtomFeedItem]
            AS a
            WHERE a.[ItemType]
            IN @contractTypes 
            ORDER BY row_number() OVER(ORDER BY a.[Id] ASC)
            OFFSET @skip ROWS FETCH NEXT @pageSize ROWS ONLY";

            return _sqlConnection.Query<AtomFeedItem>(sql, new { @skip = skip, @pageSize = PageSize, @contractTypes = ContractTypes }).ToList();
        }

        protected int GetPageCount()
        {
            var totalEntries = GetCountOfRows();
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
    }
}
