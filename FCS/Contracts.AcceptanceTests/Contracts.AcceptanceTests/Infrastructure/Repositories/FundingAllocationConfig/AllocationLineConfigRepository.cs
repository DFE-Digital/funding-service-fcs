namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories.FundingAllocationConfig
{
    using Dapper;
    using PerformanceManagementDomain.DataStore;

    public static class AllocationLineConfigRepository
    {
        public static void ClearAll()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_DynamicClearData @table,@schema,@ReqType", new { Table = "AllocationLineConfig", Schema = "FundingAllocation", ReqType = "Delete" });

            }
        }

        public static void Insert(
            string fundingStreamCode,
            string periodId,
            string fundingLineCode,
            string providerCategory,
            string fspCode,
            int deliverableCode)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_AllocationLineConfigInsert @fundingStreamCode,@periodId,@fundingLineCode,@providerCategory,@fspCode,@deliverableCode", new
                {
                    fundingStreamCode,
                    periodId,
                    fundingLineCode,
                    providerCategory,
                    fspCode,
                    deliverableCode
                });
            }
        }
    }
}
