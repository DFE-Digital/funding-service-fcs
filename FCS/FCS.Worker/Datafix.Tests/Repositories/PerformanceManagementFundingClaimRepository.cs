namespace Datafix.Tests.Repositories
{
    using System.Configuration;
    using Infrastructure;

    public static class PerformanceManagementFundingClaimRepository
    {
        public static void UpdateFundingClaimClaimTypeName(string oldClaimTypeName, string newClaimTypeName)
        {
            string connectionString =
                ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                const string sql = @"update [PerformanceManagement].[FundingClaim]
                                     set ClaimTypeName = @newClaimTypeName
                                     where ClaimTypeName = @oldClaimTypeName";

                connection.Execute(sql, param: new
                {
                    oldClaimTypeName,
                    newClaimTypeName
                });
            }
        }
    }
}
