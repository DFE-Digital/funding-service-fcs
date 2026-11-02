namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories.FundingAllocationConfig
{
    using ContractManagement.DataStore;
    using Dapper;
    using PerformanceManagementDomain.DataStore;

    public static class AllocationFundingStreamConfigRepository
    {
        public static void ClearAll()
        {
            using (var context = new ContractManagementDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_DynamicClearData @table,@schema,@ReqType", new { Table = "AllocationFundingStreamConfig", Schema = "FundingAllocation", ReqType = "Truncate" });

            }
        }

        public static void Insert(
            string allocationFundingStreamCode,
            string allocationPeriodId,
            string fundingTypeCode,
            string fundingPeriodCode,
            string fspGroupCode)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_AllocationFundingStreamConfigInsert @allocationFundingStreamCode,@allocationPeriodId,@fundingTypeCode,@fundingPeriodCode,@fspGroupCode", new
                {
                    allocationFundingStreamCode,
                    allocationPeriodId,
                    fundingTypeCode,
                    fundingPeriodCode,
                    fspGroupCode
                });
            }
        }
    }
}
