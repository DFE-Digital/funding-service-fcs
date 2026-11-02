namespace Datafix.Tests.Repositories
{
    using System.Configuration;
    using Infrastructure;

    public static class PerformanceManagementFundingClaimDeliverableRepository
    {
        public static void InsertEmptyDeliverable(string allocationId, int deliverableCode)
        {
            string connectionString =
                ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                const string sql = @"INSERT into [PerformanceManagement].[FundingClaimDeliverable]
                                    ([ContractAllocationId]
                                      ,[DeliverableCode]
                                      ,[ActualValue]
                                      ,[ForecastValue]
                                      ,[AdjustmentValue]
                                      ,[TotalDelivery])
                                    values(@allocationId, @deliverableCode, 0,0,0,null)";

                connection.Execute(sql, param: new
                {
                    allocationId,
                    deliverableCode
                });
            }
        }
    }
}
