namespace Datafix.Tests.Repositories
{
    using System.Configuration;
    using Infrastructure;

    public static class PerformanceManagementFspDeliverableClaimRepository
    {
        public static void RemoveDeliverableFromFsp(string fspCode, int deliverableCode)
        {
            string connectionString =
                ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                const string sql = @"delete from [PerformanceManagement].[FspDeliverableClaim]
                                     where FspCode = @fspCode
                                     and DeliverableCode = @deliverableCode";

                connection.Execute(sql, param: new
                {
                    fspCode,
                    deliverableCode
                });
            }
        }

        public static void InsertDeliverable(
            string fspCode,
            int deliverableCode,
            bool allowClaim,
            string claimReconciliationDeliverableGroupCode,
            string deliverableName,
            int parentDeliverableCode,
            bool allowProfile)
        {
            string connectionString =
                ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                const string sql = @"Insert into [PerformanceManagement].[FspDeliverableClaim]
                                    ([FspCode]
                                      ,[DeliverableCode]
                                      ,[AllowClaim]
                                      ,[ClaimReconciliationDeliverableGroupCode]
                                      ,[DeliverableName]
                                      ,[ParentDeliverableCode]
                                      ,[AllowProfile])
                                     values(@fspCode,
                                            @deliverableCode,
                                            @allowClaim,
                                            @claimReconciliationDeliverableGroupCode,
                                            @deliverableName,
                                            @parentDeliverableCode,
                                            @allowProfile)";

                connection.Execute(sql, param: new
                {
                    fspCode,
                    deliverableCode,
                    allowClaim,
                    claimReconciliationDeliverableGroupCode,
                    deliverableName,
                    parentDeliverableCode,
                    allowProfile
                });
            }
        }
    }
}
