namespace ContractManagementService.Repositories
{
    using Dapper;
    using DTOs;
    using SFA.FCS.Worker.Common;
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.Linq;

    public class AllocationDeliveryEntryQueryRepository : IAllocationDeliveryEntryQueryRepository
    {
        private readonly IFcsConfiguration _configuration;

        public AllocationDeliveryEntryQueryRepository(IFcsConfiguration configuration)
        {
            _configuration = configuration;
        }

        public int PageSize => 10;

        public int? GetNextPageNumber(int? requestedPage)
        {
            int? nextPage = null;
            if (requestedPage.HasValue)
            {
                nextPage = requestedPage + 1;

                int totalItems = GetTotalRowCount();
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

        private bool IsRequestedPageWithinRange(int? requestedPage, int totalItems, int nextPageStart)
        {
            // because we 'mutate' the request page number (see the controller) a requestedPage of 1 becomes 0
            return requestedPage >= 0 && nextPageStart < totalItems;
        }

        public int? GetPreviousPageNumber(int page)
        {
            return (--page < 0) ? (int?)null : page;
        }

        public StoragePage<AllocationDeliveryEntry> GetEntitiesForPage(int page)
        {
            int skip = page * PageSize;

            const string sql = @"SELECT 
    atomFeed.[ID] AS [ID], 
    atomFeed.[Identifier] AS [Identifier], 
    atomFeed.[AllocationDeliveryCategory] AS [AllocationDeliveryCategory], 
    atomFeed.[CreatedDate] AS [CreatedDate], 
    atomFeed.[AllocationNumber] AS [AllocationNumber], 
    atomFeed.[VersionNumber] AS [VersionNumber], 
    atomFeed.[SubVersionNumber] AS [SubVersionNumber], 
    atomFeed.[ContractNumber] AS [ContractNumber], 
    atomFeed.[SchemaVersion] AS [SchemaVersion]
    FROM [AllocationDelivery].[AllocationDeliveryEntry] AS atomFeed
    ORDER BY row_number() OVER (ORDER BY atomFeed.[ID] ASC)
    OFFSET @skip ROWS FETCH NEXT @pageSize ROWS ONLY";

            using (var connection = new SqlConnection(ConnectionString))
            {
                IReadOnlyCollection<AllocationDeliveryEntryWithoutBytes> entryWithoutByteCollection = connection.Query<AllocationDeliveryEntryWithoutBytes>(sql, new { @skip = skip, @pageSize = PageSize }).ToList();

                IList<AllocationDeliveryEntry> entries = ToAllocationDeliverEntries(connection, entryWithoutByteCollection);

                return new StoragePage<AllocationDeliveryEntry>
                {
                    PageNumber = page,
                    Rows = entries
                };
            }
        }

        public StoragePage<AllocationDeliveryEntry> GetEntitiesForLatestPage()
        {
            const string sql = @"SELECT TOP (@rowsInLatestPage) 
    [Extent1].[ID] AS [ID], 
    [Extent1].[Identifier] AS [Identifier], 
    [Extent1].[AllocationDeliveryCategory] AS [AllocationDeliveryCategory], 
    [Extent1].[CreatedDate] AS [CreatedDate], 
    [Extent1].[AllocationNumber] AS [AllocationNumber], 
    [Extent1].[VersionNumber] AS [VersionNumber], 
    [Extent1].[SubVersionNumber] AS [SubVersionNumber], 
    [Extent1].[ContractNumber] AS [ContractNumber], 
    [Extent1].[SchemaVersion] AS [SchemaVersion]
    FROM [AllocationDelivery].[AllocationDeliveryEntry] AS [Extent1]
    ORDER BY [Extent1].[ID] DESC
";

            var rowCountInfo = GetRowCountInfo();

            int skip = rowCountInfo.PageCount * PageSize;
            int rowsInLatestPage = rowCountInfo.TotalRows - skip;

            using (var connection = new SqlConnection(ConnectionString))
            {
                IReadOnlyCollection<AllocationDeliveryEntryWithoutBytes> entryWithoutByteCollection = connection.Query<AllocationDeliveryEntryWithoutBytes>(sql, new { @rowsInLatestPage = rowsInLatestPage }).ToList();

                IList<AllocationDeliveryEntry> entries = ToAllocationDeliverEntries(connection, entryWithoutByteCollection);

                entries = entries.OrderBy(e => e.ID).ToList();

                return new StoragePage<AllocationDeliveryEntry>
                {
                    PageNumber = rowCountInfo.PageCount,
                    Rows = entries
                };
            }
        }

        private IList<AllocationDeliveryEntry> ToAllocationDeliverEntries(SqlConnection sqlConnection,
            IReadOnlyCollection<AllocationDeliveryEntryWithoutBytes> allocationDeliveryEntryWithoutByteCollection)
        {
            IReadOnlyCollection<AllocationDeliveryEntryBytes> allocationDeliveryEntryByteCollection = GetBytesForIds(
                sqlConnection,
                allocationDeliveryEntryWithoutByteCollection.Select(i => i.Id).ToList());

            return allocationDeliveryEntryWithoutByteCollection.Select(feedItem => new AllocationDeliveryEntry
            {
                ID = feedItem.Id,
                Identifier = feedItem.Identifier,
                AllocationDeliveryCategory = feedItem.AllocationDeliveryCategory,
                CreatedDate = feedItem.CreatedDate,
                AllocationNumber = feedItem.AllocationNumber,
                VersionNumber = feedItem.VersionNumber,
                SubVersionNumber = feedItem.SubVersionNumber,
                ContractNumber = feedItem.ContractNumber,
                SchemaVersion = feedItem.SchemaVersion,
                CorporateAllocationDeliveryBytes =
                    allocationDeliveryEntryByteCollection.Single(i => i.Id == feedItem.Id).Bytes
            }).ToList();
        }

        //public AllocationDeliveryEntry GetItemById(int id)
        //{
        //    return null; // th
        //}

        public bool Any()
        {
            return GetTotalRowCount() > 0;
        }

        private RowCountInfo GetRowCountInfo()
        {
            var totalEntries = GetTotalRowCount();

            int pageCount = (int)Math.Floor(totalEntries / (double)PageSize);

            if (totalEntries > 0)
            {
                // if don't have a remainder then we need to make the reduce the pageCount
                int remainder = totalEntries % PageSize;
                if (remainder == 0)
                {
                    pageCount--;
                }
            }

            return new RowCountInfo(totalEntries, pageCount);
        }

        private int GetTotalRowCount()
        {
            const string sql = @"SELECT count(1) FROM [AllocationDelivery].[AllocationDeliveryEntry]";

            using (var connection = new SqlConnection(ConnectionString))
            {
                return connection.ExecuteScalar<int>(sql);
            }
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

        private class AllocationDeliveryEntryBytes
        {
            public int Id { get; set; }

            public byte[] Bytes { get; set; }
        }

        private class AllocationDeliveryEntryWithoutBytes
        {
            public int Id { get; set; }

            public Guid Identifier { get; set; }

            public AllocationDeliveryEntryCategory AllocationDeliveryCategory { get; set; }

            public string AllocationNumber { get; set; }

            public int? VersionNumber { get; set; }

            public int? SubVersionNumber { get; set; }

            public string ContractNumber { get; set; }

            public string SchemaVersion { get; set; }

            public DateTime CreatedDate { get; set; }
        }

        private IReadOnlyCollection<AllocationDeliveryEntryBytes> GetBytesForIds(SqlConnection sqlConnection, IReadOnlyCollection<int> ids)
        {
            const string sql = @"SELECT 
    [Extent1].[EntryID] AS Id, 
    [Extent1].[CorporateAllocationDeliveryBytes] AS Bytes
    FROM [AllocationDelivery].[AllocationDeliveryEntryData] AS [Extent1]
    WHERE [Extent1].[EntryID] IN @entryIds";

            return sqlConnection.Query<AllocationDeliveryEntryBytes>(sql, new { @entryIds = ids }).ToList();
        }

        private string ConnectionString => _configuration["ConnectionStrings:AllocationDeliveryDBContext"];
    }
}
