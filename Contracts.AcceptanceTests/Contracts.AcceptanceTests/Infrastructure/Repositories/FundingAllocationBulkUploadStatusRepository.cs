namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using Dapper;
    using PerformanceManagementDomain.DataStore;

    public class FundingAllocationBulkUploadStatusRepository
    {
        public static void ClearDown()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Connection.ExecuteScalar<int>("dbo.sp_DynamicClearData @table,@schema,@ReqType", new { Table = "BulkUploadStatus", Schema = "FundingAllocation", ReqType = "Delete" });

            }
        }

        public static void AddOrUpdateBulkUploadStatus(string fundingTypeCode, string fundingPeriodName, string status)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Connection.Execute("delete from [FundingAllocation].[BulkUploadStatus] " +
                                                        "where FundingTypeCode = fundingTypeCode and FundingPeriodName = @fundingPeriodName", 
                                                        param: new {fundingTypeCode, fundingPeriodName, status});
                Guid id = Guid.NewGuid();
                context.Database.Connection.Execute("insert [FundingAllocation].[BulkUploadStatus] ([BulkUploadBatchId],[FundingTypeCode],[FundingPeriodName],[Status]) " +
                                                        "values (@id, @fundingTypeCode, @fundingPeriodName, @status)", 
                                                        param: new { id, fundingTypeCode, fundingPeriodName, status });
            }
        }
    }
}