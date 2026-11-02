namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories.FundingAllocationConfig
{
    using Dapper;
    using PerformanceManagementDomain.DataStore;

    public static class ProviderTypeConfigRepository
    {
        public static void ClearAll()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_DynamicClearData @table,@schema,@ReqType", new { Table = "ProviderTypeConfig", Schema = "FundingAllocation", ReqType = "Truncate" });

            }
        }

        public static void Insert(
            string type,
            string subType,
            string category)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_ProviderTypeConfig @type,@subType,@category", new
                {
                    type,
                    subType,
                    category
                });
            }
        }
    }
}
