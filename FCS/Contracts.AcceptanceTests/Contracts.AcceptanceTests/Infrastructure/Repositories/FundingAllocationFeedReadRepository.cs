namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using Dapper;
    using PerformanceManagementDomain.DataStore;

    public class FundingAllocationFeedReadRepository
    {
        public static void ClearAll()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_DynamicClearData @table,@schema,@ReqType", new { Table = "FeedRead", Schema = "FundingAllocation", ReqType = "Delete" });
            }
        }
    }
}