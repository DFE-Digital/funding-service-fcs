namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories.FundingAllocationConfig
{
    using Dapper;
    using PerformanceManagementDomain.DataStore;

    public static class CfsCodesToContractTypeConfigRepository
    {
        public static void ClearAll()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_DynamicClearData @table,@schema,@ReqType", new { Table = "CfsCodesToContractTypeConfig", Schema = "FundingAllocation", ReqType = "Truncate" });

            }
        }

        public static void Insert(
            string fundingTypeCode,
            string fundingPeriodCode,
            string providerCategory,
            string contractType)
        {
            using (var context = new PerformanceManagementDbContext())
            {

                context.Database.Connection.ExecuteScalar<int>("dbo.sp_CfsCodesToContractTypeConfigInsert @fundingTypeCode,@fundingPeriodCode,@providerCategory,@contractType", new
                {
                    fundingTypeCode,
                    fundingPeriodCode,
                    providerCategory,
                    contractType
                });
            }
        }
    }
}
