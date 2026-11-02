namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using ExcelTypes;

    public class FundingAllocationCfsCodesToContractTypeConfigWriter
    {
        public static int count = 0;
        public static readonly string schemaName = "FundingAllocation";
        public static readonly string tableName = "CfsCodesToContractTypeConfig";

        public static List<string> columnFields = new List<string>() { "FundingTypeCode", "FundingPeriodCode", "ProviderCategory", "ContractType" };


        public static void WriteToPaaSDatabase(IEnumerable<CfsCodesToContractTypeSheetType> rows, WriterBehaviour behaviour)
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
                    rows.Where(st => st.PolicyStatus == PolicyStatus.Removed)
                        .ToList()
                        .ForEach(row => DeleteRow(row, connection));
                }
            }
        }

        private static void InsertRow(CfsCodesToContractTypeSheetType row, SqlConnection connection)
        {
            count = 4;
            connection.Execute("dbo.sp_config_dynamic_InsertRow", dynamicValues(row), commandType: CommandType.StoredProcedure);
        }

        private static void UpdateRow(CfsCodesToContractTypeSheetType row, SqlConnection connection)
        {
            count = 4;
            connection.Execute("dbo.sp_config_dynamic_UpdateRow", dynamicValues(row), commandType: CommandType.StoredProcedure);
        }

        private static bool IsRowPresent(CfsCodesToContractTypeSheetType row, SqlConnection connection)
        {
            count = 3;
            return connection.ExecuteScalar<int>("sp_config_dynamic_IsRowPresent", dynamicValues(row), commandType: CommandType.StoredProcedure) == 1;
        }

        private static void DeleteRow(CfsCodesToContractTypeSheetType row, SqlConnection connection)
        {
            connection.ExecuteScalar<int>("sp_config_dynamic_DeleteRow", dynamicValues(row), commandType: CommandType.StoredProcedure);
        }

        private static DynamicParameters dynamicValues(CfsCodesToContractTypeSheetType row)
        {
            var parameters = new DynamicParameters();

            if (count == 3)
            {

                parameters.Add("count", count);
                parameters.Add("schemaName", schemaName);
                parameters.Add("tableName", tableName);
                parameters.Add("param1", row.FundingTypeCode);
                parameters.Add("param2", row.FundingPeriodCode);
                parameters.Add("param3", row.ProviderCategory);
                parameters.Add("column1", columnFields[0]);
                parameters.Add("column2", columnFields[1]);
                parameters.Add("column3", columnFields[2]);
            }
            else
            {
                parameters.Add("count", count);
                parameters.Add("schemaName", schemaName);
                parameters.Add("tableName", tableName);
                parameters.Add("param1", row.FundingTypeCode);
                parameters.Add("param2", row.FundingPeriodCode);
                parameters.Add("param3", row.ProviderCategory);
                parameters.Add("param4", row.ContractType);
                parameters.Add("column1", columnFields[0]);
                parameters.Add("column2", columnFields[1]);
                parameters.Add("column3", columnFields[2]);
                parameters.Add("column4", columnFields[3]);
            }
            return parameters;
        }
    }
}