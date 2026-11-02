namespace Datafix.Tests.Repositories
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;

    public static class FundingAllocationContractRepository
    {
        public static IReadOnlyCollection<(string contractNumber, int version)> GetContracts()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            const string sql = @"SELECT distinct c.ContractNumber,
                                                 c.ContractVersionNumber
                                 FROM [FundingAllocation].[Contract] c
                                 where [RelationshipToFundingAllocation] = 'Created'";

            using (var connection = new SqlConnection(connectionString))
            {
                return connection.Query<(string contractNumber, int version)>(sql)
                    .ToList();
            }
        }

        public static IReadOnlyCollection<string> GetFundingAllocationIdsRelatedToContract(string contractNumber, int version)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            const string sql = @"
SELECT fa.FundingId
FROM [FundingAllocation].[Contract] c,
       [FundingAllocation].[FundingAllocation] fa
where c.Id = fa.ContractId
and c.ContractNumber = @contractNumber
and c.ContractVersionNumber = @version
and c.[RelationshipToFundingAllocation] = 'Created'
and fa.CrmEntityId is not null";

            using (var connection = new SqlConnection(connectionString))
            {
                return connection.Query<string>(sql, new {contractNumber, version})
                    .ToList();
            }
        }

        public static void SetFundingAllocationsToPublished(IEnumerable<string> fundingIds)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            const string sql = @"update [FundingAllocation].[FundingAllocation] 
                                 set IsPublished = 1
                                where FundingId in @fundingIds";

            using (var connection = new SqlConnection(connectionString))
            {
                 connection.Execute(sql,
                    param: new {fundingIds});
            }
        }
    }
}
