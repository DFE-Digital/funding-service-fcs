namespace Datafix.Tests.Repositories
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using Dtos;

    public class FundingClaimKeyRepository : IFundingClaimKeyRepository
    {
        public IReadOnlyCollection<FundingClaimKey> GetKeys(string period, string claimTypeName)
        {
            const string sql =
                @"SELECT 
                      [OrganisationIdentifier]
                      ,[VersionNumber]
                      ,[ClaimTypeName]
                      ,[PeriodTypeCode]
                      ,[Period]
                 
                  FROM [PerformanceManagement].[FundingClaim]
                  where period = @period
                  and ClaimTypeName = @claimTypeName";

            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                return connection.Query<FundingClaimKey>(sql,
                        new { period, claimTypeName }).ToList();
            }
        }
    }

    public interface IFundingClaimKeyRepository
    {
        IReadOnlyCollection<FundingClaimKey> GetKeys(string period, string claimTypeName);
    }
}
