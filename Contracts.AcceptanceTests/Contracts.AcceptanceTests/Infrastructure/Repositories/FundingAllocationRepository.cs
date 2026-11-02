namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using Dapper;
    using DTO.Cfs;
    using PerformanceManagementDomain.DataStore;

    public static class FundingAllocationRepository
    {
        public static void ClearFundingAllocationPageControlTable()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_DynamicClearData @table,@schema,@ReqType", new { Table = "FundingAllocationPageControl", Schema = "FundingAllocation", ReqType = "Delete" });
            }
        }

        public static FundingAllocationDto GetByFundingId(string fundingId)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                return context.Database.Connection.QuerySingleOrDefault<FundingAllocationDto>("sp_FundingAllocationGetByFundingId @fundingId", new { fundingId });
            }
        }

        public static bool ParkingAndDiscardedInfoExists(string fundingId)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                const string sql = @"
                SELECT 
                    COUNT(1) FROM [FundingAllocation].[ParkingAndDiscardedInfo]
                WHERE 
                    [FundingAllocationId] = @fundingId";

                var count = context.Database.Connection.ExecuteScalar<int>(
                    sql: sql,
                    param: new { fundingId });

                return count == 1;
            }
        }
    }
}
