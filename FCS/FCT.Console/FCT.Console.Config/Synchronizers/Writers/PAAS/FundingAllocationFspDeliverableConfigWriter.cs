namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using ExcelTypes;

    public class FundingAllocationFspDeliverableConfigWriter
    {
        public static int count = 0;
        public static readonly string schemaName = "FundingAllocation";
        public static readonly string tableName = "FspDeliverableConfig";

        public static List<string> columnFields = new List<string>() { "FspCode", "DeliverableCode", "DeliverableName", "DisplayOrder" };
        public static void WriteToPaaSDatabase(IEnumerable<FundingStreamPeriodDeliverablesSheetType> rows, WriterBehaviour behaviour)
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

        private static void InsertRow(FundingStreamPeriodDeliverablesSheetType row, SqlConnection connection)
        {
            connection.Execute("sp_config_FspDeliverables_InsertRow @FundingStreamPeriodCode,@DeliverableCode,@DeliverableName,@DisplayOrder", new { FundingStreamPeriodCode=row.FspCode, DeliverableCode=row.DeliverableCode, DeliverableName=row.DeliverableName, DisplayOrder=row.DisplayOrder});           
        }

        private static void UpdateRow(FundingStreamPeriodDeliverablesSheetType row, SqlConnection connection)
        {
            connection.Execute("sp_config_FspDeliverables_UpdateRow @FundingStreamPeriodCode,@DeliverableCode,@DeliverableName,@DisplayOrder", new { FundingStreamPeriodCode = row.FspCode, DeliverableCode = row.DeliverableCode, DeliverableName = row.DeliverableName, DisplayOrder = row.DisplayOrder });
        }

        private static bool IsRowPresent(FundingStreamPeriodDeliverablesSheetType row, SqlConnection connection)
        {
            count = 2;
            return connection.ExecuteScalar<int>("sp_config_dynamic_IsRowPresent", dynamicValues(row), commandType: CommandType.StoredProcedure) == 1;
        }

        private static void DeleteRow(FundingStreamPeriodDeliverablesSheetType row, SqlConnection connection)
        {
            count = 2;
            connection.ExecuteScalar<int>("sp_config_dynamic_DeleteRow", dynamicValues(row), commandType: CommandType.StoredProcedure);
        }

        private static DynamicParameters dynamicValues(FundingStreamPeriodDeliverablesSheetType row)
        {
            var parameters = new DynamicParameters();

            if (count == 2)
            {
                parameters.Add("count", count);
                parameters.Add("schemaName", schemaName);
                parameters.Add("tableName", tableName);
                parameters.Add("param1", row.FspCode);
                parameters.Add("param2", row.DeliverableCode);
                parameters.Add("column1", columnFields[0]);
                parameters.Add("column2", columnFields[1]);
            }
            else
            {
                parameters.Add("count", count);
                parameters.Add("schemaName", schemaName);
                parameters.Add("tableName", tableName);
                parameters.Add("param1", row.FspCode);
                parameters.Add("param2", row.DeliverableCode);
                parameters.Add("param3", row.DeliverableName);
                parameters.Add("param4", row.DisplayOrder);
                parameters.Add("column1", columnFields[0]);
                parameters.Add("column2", columnFields[1]);
                parameters.Add("column3", columnFields[2]);
                parameters.Add("column4", columnFields[3]);
            }
            return parameters;
        }
    }
}
