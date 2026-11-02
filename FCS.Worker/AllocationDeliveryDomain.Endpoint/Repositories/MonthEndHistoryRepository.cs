namespace AllocationDeliveryDomain.Endpoint.Repositories
{
    using System.Data;
    using System.Threading.Tasks;
    using Dapper;

    public class MonthEndHistoryRepository : IMonthEndStartRepository
    {
        public async Task CreateNewMonthEndEntry(IDbConnection connection, IDbTransaction transaction)
        {
            const string sql = @"insert into [ContractManagement].[MonthEndHistory] (EndTime) values (null)";

            await connection.ExecuteAsync(sql, transaction: transaction);
        }
    }
}
