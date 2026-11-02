namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using ExcelTypes;

    public class StatusSubStatusConfigWriter
    {
        public static int count = 0;
        public static readonly string schemaName = "FundingAllocation";
        public static readonly string tableName = "StatusSubStatusConfig";
        public static List<string> columnFields = new List<string>() { "Status", "SubStatus" };

        public static void WriteToPaaSDatabase(IEnumerable<StatusSubStatusConfigType> rows, WriterBehaviour behaviour)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            if (behaviour == WriterBehaviour.AddOrUpdate)
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    rows.ToList().ForEach(row =>
                    {
                        if (!IsRowPresent(row, connection))
                        {
                            InsertRow(row, connection);
                        }
                    });
                }
            }
        }

        private static void InsertRow(StatusSubStatusConfigType row, SqlConnection connection)
        {
            count = 2;        

            connection.Execute("dbo.sp_config_dynamic_InsertRow", dynamicValues(row), commandType: System.Data.CommandType.StoredProcedure);
        }

        private static bool IsRowPresent(StatusSubStatusConfigType row, SqlConnection connection)
        {
            count = 2;
            return connection.ExecuteScalar<int>("sp_config_dynamic_IsRowPresent", dynamicValues(row), commandType: CommandType.StoredProcedure) == 1;
        }

        private static DynamicParameters dynamicValues(StatusSubStatusConfigType row)
        {
            var parameters = new DynamicParameters();

            parameters.Add("count", count);
            parameters.Add("schemaName", schemaName);
            parameters.Add("tableName", tableName);
            parameters.Add("param1", row.Status);
            parameters.Add("param2", row.SubStatus);
            parameters.Add("column1", columnFields[0]);
            parameters.Add("column2", columnFields[1]);

            return parameters;
        }
    }
}
