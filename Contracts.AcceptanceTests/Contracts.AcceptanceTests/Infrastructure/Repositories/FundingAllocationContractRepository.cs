namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using Dapper;
    using DTO.Cfs;
    using PerformanceManagementDomain.DataStore;

    public static class FundingAllocationContractRepository
    {
        public static void ClearAll()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_DynamicClearData @table,@Schema,@ReqType", new { Table = "Contract", Schema = "FundingAllocation", ReqType = "Delete" });

            }
        }

        public static FundingAllocationContract GetByFundingId(string fundingId)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                return context.Database.Connection.Query<FundingAllocationContract>("dbo.sp_GetByFundingAllocationFundingId @fundingId", new { fundingId }).SingleOrDefault();
            }
        }

        public static void ClearProcessedMessageTable()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_DynamicClearData @table,@schema,@ReqType", new { Table = "ProcessedMessage", Schema = "FundingAllocation", ReqType = "Delete" });
            }
        }

    }
}