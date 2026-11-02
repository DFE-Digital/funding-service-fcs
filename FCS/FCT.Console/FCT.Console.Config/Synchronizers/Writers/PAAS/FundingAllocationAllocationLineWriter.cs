namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using ExcelTypes;

    public static class FundingAllocationAllocationLineWriter
    {
        public static int count = 0;
        public static readonly string schemaName = "FundingAllocation";
        public static readonly string tableName = "AllocationLineConfig";

        public static List<string> columnFields = new List<string>() { "FundingStreamCode", "PeriodId", "FundingLineCode", "ProviderCategory", "FspCode", "DeliverableCode" };

        public static void WriteToPaaSDatabase(IEnumerable<AllocationLinesSheet> rows, WriterBehaviour behaviour)
        {
            // any connection string is fine here
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            if (behaviour == WriterBehaviour.AddOrUpdate)
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    rows.ToList().Where(so => so.PolicyStatus == PolicyStatus.Approved).ToList().ForEach(row =>
                    {
                        if (IsRowPresent(row, connection))
                        {
                            UpdateRow(row, connection);
                        }
                        else
                        {
                            InsertRow(row, connection);
                        }
                    });
                }
            }
            else
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    rows.ToList().Where(so => so.PolicyStatus == PolicyStatus.Removed)
                        .ToList()
                        .ForEach(row => DeleteRow(row, connection));
                }
            }
        }

        private static void InsertRow(AllocationLinesSheet row, SqlConnection connection)
        {
            count = 6;
            connection.Execute("dbo.sp_config_dynamic_InsertRow", dynamicValues(row), commandType: System.Data.CommandType.StoredProcedure);
        }

        private static void UpdateRow(AllocationLinesSheet row, SqlConnection connection)
        {
            count = 6;
            connection.Execute("dbo.sp_config_dynamic_UpdateRow", dynamicValues(row), commandType: System.Data.CommandType.StoredProcedure);
        }

        private static bool IsRowPresent(AllocationLinesSheet row, SqlConnection connection)
        {
            count = 4;
            return connection.ExecuteScalar<int>("sp_config_dynamic_IsRowPresent", dynamicValues(row), commandType: CommandType.StoredProcedure) == 1;
        }

        private static void DeleteRow(AllocationLinesSheet row, SqlConnection connection)
        {
            count = 4;
            connection.ExecuteScalar<int>("sp_config_dynamic_DeleteRow", dynamicValues(row), commandType: CommandType.StoredProcedure);
        }

        private static DynamicParameters dynamicValues(AllocationLinesSheet row)
        {
            var parameters = new DynamicParameters();

            if (count == 4)
            {
                parameters.Add("count", count);
                parameters.Add("schemaName", schemaName);
                parameters.Add("tableName", tableName);
                parameters.Add("param1", row.AllocationFundingStreamCode);
                parameters.Add("param2", row.AllocationPeriodId);
                parameters.Add("param3", row.AllocationFundingLineCode);
                parameters.Add("param4", row.ProviderCategory);
                parameters.Add("column1", columnFields[0]);
                parameters.Add("column2", columnFields[1]);
                parameters.Add("column3", columnFields[2]);
                parameters.Add("column4", columnFields[3]);
            }
            else
            {
                parameters.Add("count", count);
                parameters.Add("schemaName", schemaName);
                parameters.Add("tableName", tableName);
                parameters.Add("param1", row.AllocationFundingStreamCode);
                parameters.Add("param2", row.AllocationPeriodId);
                parameters.Add("param3", row.AllocationFundingLineCode);
                parameters.Add("param4", row.ProviderCategory);
                parameters.Add("param5", row.FspCode);
                parameters.Add("param6", row.DeliverableCode);
                parameters.Add("column1", columnFields[0]);
                parameters.Add("column2", columnFields[1]);
                parameters.Add("column3", columnFields[2]);
                parameters.Add("column4", columnFields[3]);
                parameters.Add("column5", columnFields[4]);
                parameters.Add("column6", columnFields[5]);
            }
            return parameters;
        }
    }
}
