namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using ExcelTypes;

    public class FundingAllocationFundingStreamPeriodConfigWriter
    {
        public static int count = 0;
        public static string processType;
        public static readonly string schemaName = "FundingAllocation";
        public static readonly string tableName = "FundingStreamPeriodConfig";
        public static List<string> columnFields = new List<string>() { "FundingStreamPeriodCode", "FundingStreamCode", "AllocationReferencePrefix", "StartDate", "EndDate" };

        public static void WriteToPaaSDatabase(IEnumerable<FundingStreamPeriodSheetType> rows, WriterBehaviour behaviour)
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

        private static void InsertRow(FundingStreamPeriodSheetType row, SqlConnection connection)
        {
            processType = "InsertRow";
            connection.Execute("sp_config_fa_fsp_Dynamic", dynamicValues(row), commandType: CommandType.StoredProcedure);
            processType = null;
        }

        private static void UpdateRow(FundingStreamPeriodSheetType row, SqlConnection connection)
        {
            processType = "UpdateRow";
            connection.Execute("sp_config_fa_fsp_Dynamic", dynamicValues(row), commandType: CommandType.StoredProcedure);
            processType = null;
        }

        private static bool IsRowPresent(FundingStreamPeriodSheetType row, SqlConnection connection)
        {
            count = 1;
            return connection.ExecuteScalar<int>("sp_config_dynamic_IsRowPresent", dynamicValues(row), commandType: CommandType.StoredProcedure) == 1;
        }

        private static void DeleteRow(FundingStreamPeriodSheetType row, SqlConnection connection)
        {
            count = 1;
            connection.ExecuteScalar<int>("sp_config_dynamic_DeleteRow", dynamicValues(row), commandType: CommandType.StoredProcedure);
        }

        private static DynamicParameters dynamicValues(FundingStreamPeriodSheetType row)
        {
            var parameters = new DynamicParameters();

            if (processType != null)
            {
                parameters.Add("processType", processType);
                parameters.Add("schemaName", schemaName);
                parameters.Add("tableName", tableName);
                parameters.Add("param1", row.FundingStreamPeriodCode);
                parameters.Add("param2", row.FundingStreamCode);
                parameters.Add("param3", row.AllocationReferencePrefix);
                parameters.Add("param4", row.StartDate);
                parameters.Add("param5", row.EndDate);
                parameters.Add("column1", columnFields[0]);
                parameters.Add("column2", columnFields[1]);
                parameters.Add("column3", columnFields[2]);
                parameters.Add("column4", columnFields[3]);
                parameters.Add("column5", columnFields[4]);
            }
            else
            {

                parameters.Add("count", count);
                parameters.Add("schemaName", schemaName);
                parameters.Add("tableName", tableName);
                parameters.Add("param1", row.FundingStreamPeriodCode);
                parameters.Add("column1", columnFields[0]);
            }
            return parameters;
        }
    }
}