namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using ExcelTypes;

    public class FundingAllocationFundingTypeConfigWriter
    {
        public static int count = 0;
        public static readonly string schemaName = "FundingAllocation";
        public static readonly string tableName = "FundingTypeConfig";

        public static List<string> columnFields = new List<string>() { "FundingTypeCode", "ContractReferencePrefix" };
        public static void WriteToPaaSDatabase(IEnumerable<FundingTypeSheetType> rows, WriterBehaviour behaviour)
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

        private static void InsertRow(FundingTypeSheetType row, SqlConnection connection)
        {
            count = 2;
            connection.Execute("dbo.sp_config_dynamic_InsertRow", dynamicValues(row), commandType: CommandType.StoredProcedure);
        }

        private static void UpdateRow(FundingTypeSheetType row, SqlConnection connection)
        {
            count = 2;
            connection.Execute("dbo.sp_config_dynamic_UpdateRow", dynamicValues(row), commandType: CommandType.StoredProcedure);
        }

        private static bool IsRowPresent(FundingTypeSheetType row, SqlConnection connection)
        {
            count = 1;
            return connection.ExecuteScalar<int>("sp_config_dynamic_IsRowPresent", dynamicValues(row), commandType: CommandType.StoredProcedure) == 1;
        }

        private static void DeleteRow(FundingTypeSheetType row, SqlConnection connection)
        {
            count = 1;
            connection.ExecuteScalar<int>("sp_config_dynamic_DeleteRow", dynamicValues(row), commandType: CommandType.StoredProcedure);
        }

        private static DynamicParameters dynamicValues(FundingTypeSheetType row)
        {

            var parameters = new DynamicParameters();
            if (count == 1)
            {
                parameters.Add("count", count);
                parameters.Add("schemaName", schemaName);
                parameters.Add("tableName", tableName);
                parameters.Add("param1", row.FundingTypeCode);
                parameters.Add("column1", columnFields[0]);

            }
            else
            {
                parameters.Add("count", count);
                parameters.Add("schemaName", schemaName);
                parameters.Add("tableName", tableName);
                parameters.Add("param1", row.FundingTypeCode);
                parameters.Add("param2", row.ContractReferencePrefix);
                parameters.Add("column1", columnFields[0]);
                parameters.Add("column2", columnFields[1]);
            }
            return parameters;
        }
    }
}