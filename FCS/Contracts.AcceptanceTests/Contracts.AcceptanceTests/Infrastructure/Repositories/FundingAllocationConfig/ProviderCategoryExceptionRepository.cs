namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories.FundingAllocationConfig
{
    using Dapper;
    using PerformanceManagementDomain.DataStore;

    public class ProviderCategoryExceptionRepository
    {
        public static void ClearAll()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_DynamicClearData @table,@schema,@ReqType", new { Table = "ProviderCategoryException", Schema = "FundingAllocation", ReqType = "Truncate" });

            }
        }

        public static void Insert(
            string fundingTypeCode,
            string fundingPeriodCode,
            string ukprn,
            string category)
        {
            using (var context = new PerformanceManagementDbContext())
            {

                context.Database.Connection.ExecuteScalar<int>("dbo.sp_ProviderCategoryExceptionInsert @fundingTypeCode,@fundingPeriodCode,@ukprn,@category", new
                {
                    fundingTypeCode,
                    fundingPeriodCode,
                    ukprn,
                    category
                });
            }
        }
    }
}