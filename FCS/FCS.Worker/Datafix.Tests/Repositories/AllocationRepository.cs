namespace Datafix.Tests.Repositories
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;

    public static class AllocationRepository
    {
        public static List<string> GetLatestAllocationNumbersForContract(
            string contractNumber)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @"select a.AllocationNumber from [PaymentSchedule].[Allocation] a
                                where a.ContractNumber = @contractNumber
                                and a.ContractVersionNumber = (select max(ContractVersionNumber) from [PaymentSchedule].[Allocation] where ContractNumber = a.ContractNumber)";

            using (var connection = new SqlConnection(connectionString))
            {
                return connection.Query<string>(sql,
                    new { contractNumber }).ToList();
            }
        }
    }
}
