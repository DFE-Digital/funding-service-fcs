namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using ExcelTypes;

    public class FundingAllocationAllocationFundingStreamConfigWriter
    {
        public static int count = 0;
        public static readonly string tableName = "AllocationFundingStreamConfig";
        public static readonly string schemaName = "FundingAllocation";
        public static List<string> columnFields = new List<string>() { "AllocationFundingStreamCode", "AllocationPeriodId", "FundingTypeCode", "FundingPeriodCode", "FSPGroupCode" };

        public static void WriteToPaaSDatabase(IEnumerable<AllocationFundingStreamSheetType> rows, WriterBehaviour behaviour)
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

        private static void InsertRow(AllocationFundingStreamSheetType row, SqlConnection connection)
        {
            count = 5;
            connection.Execute("dbo.sp_config_dynamic_InsertRow", dynamicValues(row), commandType: CommandType.StoredProcedure);
        }

        private static void UpdateRow(AllocationFundingStreamSheetType row, SqlConnection connection)
        {
            count = 5;
            connection.Execute("dbo.sp_config_dynamic_UpdateRow", dynamicValues(row), commandType: CommandType.StoredProcedure);
        }

        private static bool IsRowPresent(AllocationFundingStreamSheetType row, SqlConnection connection)
        {
            count = 2;
            return connection.ExecuteScalar<int>("sp_config_dynamic_IsRowPresent", dynamicValues(row), commandType: CommandType.StoredProcedure) == 1;
        }

        private static void DeleteRow(AllocationFundingStreamSheetType row, SqlConnection connection)
        {
            count = 2;
            connection.ExecuteScalar<int>("sp_config_dynamic_DeleteRow", dynamicValues(row), commandType: CommandType.StoredProcedure);
        }

        private static DynamicParameters dynamicValues(AllocationFundingStreamSheetType row)
        {
            var parameters = new DynamicParameters();

            if (count == 2)
            {

                parameters.Add("count", count);
                parameters.Add("schemaName", schemaName);
                parameters.Add("tableName", tableName);
                parameters.Add("param1", row.AllocationFundingStreamCode);
                parameters.Add("param2", row.AllocationPeriodId);
                parameters.Add("column1", columnFields[0]);
                parameters.Add("column2", columnFields[1]);
            }
            else
            {
                parameters.Add("count", count);
                parameters.Add("schemaName", schemaName);
                parameters.Add("tableName", tableName);
                parameters.Add("param1", row.AllocationFundingStreamCode);
                parameters.Add("param2", row.AllocationPeriodId);
                parameters.Add("param3", row.FundingTypeCode);
                parameters.Add("param4", row.FundingPeriodCode);
                parameters.Add("param5", row.FSPGroupCode);
                parameters.Add("column1", columnFields[0]);
                parameters.Add("column2", columnFields[1]);
                parameters.Add("column3", columnFields[2]);
                parameters.Add("column4", columnFields[3]);
                parameters.Add("column5", columnFields[4]);
            }
            return parameters;
        }
    }
}