namespace Datafix.Tests.Repositories
{
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Configuration;
    using System.Data.SqlClient;
    using System;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    //using System.Windows.Documents;
    using System.Collections.Generic;

    public static class CrmReplicatedRepository
    {
        private static string ConnectionString => ConfigurationManager.ConnectionStrings["CrmDatabaseConnectionString"].ConnectionString;

        public static void DeleteDuplicateDeliverablesBasedOnId(Guid contractdeliverableId)
        {
            const string sqlQuery = "Delete from dbo.sfa_contractdeliverable where Id = @contractdeliverableId";

            ExecuteSql(sqlQuery, new { contractdeliverableId });
        }
        public static void DeleteDuplicateDeliverablesPeriodBasedOnId(Guid contractDeliverablePeriodId)
        {
            const string sqlQuery = "Delete from dbo.[sfa_contractdeliverableperiod] where Id = @contractDeliverablePeriodId";

            ExecuteSql(sqlQuery, new { contractDeliverablePeriodId });
        }

        public static IReadOnlyCollection<sfa_contract> GetDuplicateConract(string contractNumber, string version)
        {
            const string sqlQuery = "select Id , modifiedon from dbo.sfa_contract  where sfa_number = @contractNumber" +
                " and sfa_version = @version ";

            using (var connection = new SqlConnection(ConnectionString))
            {
                return connection.Query<sfa_contract>(sqlQuery,
                        new { contractNumber, version }).ToList();
            } 
        }

        public static void DeleteDuplicateConract(Guid contractId)
        {
            const string sqlQuery = "Delete from dbo.sfa_contract where Id = @contractId";

            ExecuteSql(sqlQuery, new { contractId });
        }
        public static void DeleteDuplicateAllocation(Guid contractId)
        {
            const string sqlQuery = "Delete from dbo.[sfa_contractallocation] where sfa_contractid = @contractId";

            ExecuteSql(sqlQuery, new { contractId });
        }

        public static void DeleteDuplicateConractDeliverable(Guid contractId)
        {
            const string sqlQuery = "Delete from dbo.sfa_contractdeliverable where sfa_contractallocationid" +
                " in (select Id from [dbo].[sfa_contractallocation] where sfa_contractid = @contractId)";

            ExecuteSql(sqlQuery, new { contractId });
        }

        public static void DeleteDuplicateConractDeliverablePeriod(Guid contractId)
        {
            const string sqlQuery = "Delete from dbo.sfa_contractdeliverableperiod where sfa_contractdeliverableid" +
                " in (select id from sfa_contractdeliverable where sfa_contractallocationid " +
                " in (select Id from [dbo].[sfa_contractallocation] where sfa_contractid = @contractId))";

            ExecuteSql(sqlQuery, new { contractId });
        }

        public static void UpdateDeliverablesCodeBasedOnId(string deliverableCode, string deliverableName, Guid contractdeliverableId)
        {
            const string sqlQuery = "Update sfa_contractdeliverable Set sfa_deliverablecode = @deliverableCode, sfa_deliverablename = @deliverableName  where Id = @contractdeliverableId";

            ExecuteSql(sqlQuery, new { deliverableCode, contractdeliverableId, deliverableName });
        }
        private static void ExecuteSql(string sql, object parameter)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                connection.Execute(sql, parameter);
            }
        }
         
    }
}
