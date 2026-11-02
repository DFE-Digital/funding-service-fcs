namespace AllocationDeliveryDomain.Endpoint.ActualsPull.Repositories
{
    using System;
    using System.Threading.Tasks;
    using System.Data;
    using Dapper;
    using Endpoint.Repositories;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;

    public class ClosedCollectionRepository : IClosedCollectionRepository, IClosedCollectionCompleteRepository
    {
        public static Func<DateTime> DefaultDateTime => () => new DateTime(2020, 1, 1, 0, 0, 0, DateTimeKind.Utc);

        public async Task<DateTime> GetLatestClosedDateTime(IDbConnection connection, IDbTransaction transaction)
        {
            const string sql = @"SELECT max(ClosedTime)
                FROM [MonitoringDeliverables].[ClosedCollection]";

            var date = await connection.ExecuteScalarAsync<DateTime?>(sql, transaction: transaction);

            return date ?? DefaultDateTime();
        }

        public async Task CreateClosedCollection(IDbConnection connection, IDbTransaction transaction, ClosedCollection closedCollection)
        {
            const string sql = @"insert into [MonitoringDeliverables].[ClosedCollection]
                        (CollectionType, CollectionReturnCode, ClosedTime, TotalRowCount)
                        values (@collectionType, @collectionReturnCode, @closedTime, @totalRowCount)";

            await connection.ExecuteAsync(sql, transaction: transaction, param: closedCollection);
        }

        public async Task<int> UpdateRowToCompletedIfNoOneElseHas(
            IDbConnection connection,
            IDbTransaction transaction,
            string collectionType, string collectionReturnCode,
            int rowsRetrieved)
        {
            const string sql = @"update [MonitoringDeliverables].[ClosedCollection]
                        set RetrievedRowCount = @rowsRetrieved
                        where CollectionType = @collectionType
                        and CollectionReturnCode = @collectionReturnCode
                        and RetrievedRowCount is null";

            return await connection.ExecuteAsync(sql, transaction: transaction, param: new
            {
                collectionType,
                collectionReturnCode,
                rowsRetrieved
            });
        }

        public async Task<ClosedCollection> Get(
            IDbConnection connection,
            IDbTransaction transaction,
            string collectionType, string collectionReturnCode)
        {
            const string sql = @"select [CollectionType]
                              ,[CollectionReturnCode]
                              ,[ClosedTime]
                              ,[TotalRowCount]
                              ,[RetrievedRowCount]
                        from [MonitoringDeliverables].[ClosedCollection]
                        where CollectionType = @collectionType
                        and CollectionReturnCode = @collectionReturnCode";

            return await connection.QuerySingleAsync<ClosedCollection>(sql, transaction: transaction, param: new
            {
                collectionType,
                collectionReturnCode,
            });
        }
    }
}
