namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using ExcelTypes;

    public static class FundingAllocationProviderTypeWriter
    {
        public static int count = 0;
        public static readonly string schemaName = "FundingAllocation";
        public static readonly string tableName = "ProviderTypeConfig";

        public static List<string> columnFields = new List<string>() { "Type", "Subtype", "Category" };

        public static void WriteToPaaSDatabase(IEnumerable<AllocationProviderTypeSheet> rows, WriterBehaviour behaviour)
        {            
            // any connection string is fine here
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

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

        private static void InsertRow(AllocationProviderTypeSheet row, SqlConnection connection)
        {
            count = 3;
            connection.Execute("dbo.sp_config_dynamic_InsertRow", dynamicValues(row), commandType: CommandType.StoredProcedure);
        }

        private static void UpdateRow(AllocationProviderTypeSheet row, SqlConnection connection)
        {
            count = 3;
            connection.Execute("dbo.sp_config_dynamic_UpdateRow", dynamicValues(row), commandType: CommandType.StoredProcedure);
        }

        private static bool IsRowPresent(AllocationProviderTypeSheet row, SqlConnection connection)
        {
            count = 2;
            return connection.ExecuteScalar<int>("sp_config_dynamic_IsRowPresent", dynamicValues(row), commandType: CommandType.StoredProcedure) == 1;
        }

        private static DynamicParameters dynamicValues(AllocationProviderTypeSheet row)
        {
            var parameters = new DynamicParameters();

            if (count == 2)
            {
                parameters.Add("count", count);
                parameters.Add("schemaName", schemaName);
                parameters.Add("tableName", tableName);
                parameters.Add("param1", row.ProviderType);
                parameters.Add("param2", row.ProviderSubType);
                parameters.Add("param3", null);
                parameters.Add("param4", null);
                parameters.Add("column1", columnFields[0]);
                parameters.Add("column2", columnFields[1]);
                parameters.Add("column3", null);
                parameters.Add("column4", null);
            }
            else
            {
                parameters.Add("count", count);
                parameters.Add("schemaName", schemaName);
                parameters.Add("tableName", tableName);
                parameters.Add("param1", row.ProviderType);
                parameters.Add("param2", row.ProviderSubType);
                parameters.Add("param3", row.ProviderCategory);
                parameters.Add("param4", null);
                parameters.Add("param5", null);
                parameters.Add("param6", null);
                parameters.Add("column1", columnFields[0]);
                parameters.Add("column2", columnFields[1]);
                parameters.Add("column3", columnFields[2]);
                parameters.Add("column4", null);
                parameters.Add("column5", null);
                parameters.Add("column6", null);
            }
            return parameters;
        }

    }
}
