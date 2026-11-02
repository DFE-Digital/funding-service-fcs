namespace ActualsPull.Repositories
{
    using System;
    using System.Data;
    using System.Threading.Tasks;
    using Dapper;

    public class ClosedCollectionRepository : IClosedCollectionRepository
    {
        public static Func<DateTime>DefaultDateTime => () => new DateTime(2020, 1, 1, 0, 0,0, DateTimeKind.Utc);

        public async Task<DateTime> GetLatestClosedDateTime(IDbConnection connection, IDbTransaction transaction)
        {
            const string sql = @"SELECT max(ClosedTime)
                FROM [MonitoringDeliverables].[ClosedCollection]";

            var date = await connection.ExecuteScalarAsync<DateTime?>(sql, transaction: transaction);

            return date ?? DefaultDateTime();
        }
    }
}
