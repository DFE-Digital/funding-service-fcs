namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using Dapper;
    using System.Configuration;
    using System.Data.SqlClient;
    using System;
    using System.Linq;
    using SFA.FCT.Operations.DataStore;

    public class OperationsRepository
    {
        private static string ConnectionString => TestConfiguration.Configuration["ConnectionStrings:ContractManagementDbContext"];

        public static void ClearProcessedMessageTable(string schemaName)
        {
            using (var _operationDbContext = new OperationsDbContext())
            {
                _operationDbContext.Database.Connection.ExecuteScalar<int>("dbo.sp_ClearProcessedMessageTable @schemaName", new { schemaName });
            }
        }

        public static void CreateProcessedMessageRows(string schemaName, int numberOfRecords, DateTime createDateOfProcessedMessage)
        {
            using (var _operationDbContext = new OperationsDbContext())
            {
                Enumerable.Range(1, numberOfRecords).ToList().ForEach(i => _operationDbContext.Database.Connection.Execute("dbo.sp_CreateProcessedMessageRows @schemaName,@createDateOfProcessedMessage", new { schemaName, createDateOfProcessedMessage }));

            }
        }

    }
}