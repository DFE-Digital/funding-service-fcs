namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using Dapper;
    using PerformanceManagementDomain.DataStore;

    public static class FundingAllocationProviderFunding
    {
        public static void ClearProviderFundings()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_DynamicClearData @table,@schema,@ReqType", new { Table = "ProviderFunding", Schema = "FundingAllocation", ReqType = "Delete" });

            }
        }
    }
}
