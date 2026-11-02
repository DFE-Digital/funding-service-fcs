namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using ExcelTypes;

    public class FundingAllocationFundingTypeFundingPeriodConfigWriter
    {
        public static int count = 0;
        public static string processType;
        public static readonly string schemaName = "FundingAllocation";
        public static readonly string tableName = "FundingTypeFundingPeriodConfig";

        public static List<string> columnFields = new List<string>() { "FundingTypeCode", "FundingPeriod", "FtpGroupCode", "PrecedingFtpFundingType", "PrecedingFtpFundingPeriod",
            "IncludeAllContractsOnSummaryOfFunding","AllowNewAmendment","AllAmendmentsRequireSigning","ContractExpiryDate" };

        public static void WriteToPaaSDatabase(IEnumerable<FundingTypePeriodSheetType> rows, WriterBehaviour behaviour)
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

        private static void InsertRow(FundingTypePeriodSheetType row, SqlConnection connection)
        {
            processType = "InsertRow";
            connection.Execute("sp_Config_FA_FTFP_Dynamic", dynamicValues(row), commandType: CommandType.StoredProcedure);            
            processType = null;
        }

        private static void UpdateRow(FundingTypePeriodSheetType row, SqlConnection connection)
        {
            processType = "UpdateRow";
            connection.Execute("sp_Config_FA_FTFP_Dynamic", dynamicValues(row), commandType: CommandType.StoredProcedure);
            processType = null;
        }

        private static bool IsRowPresent(FundingTypePeriodSheetType row, SqlConnection connection)
        {
            count = 2;
            return connection.ExecuteScalar<int>("sp_config_dynamic_IsRowPresent", dynamicValues(row), commandType: CommandType.StoredProcedure) == 1;
        }

        private static void DeleteRow(FundingTypePeriodSheetType row, SqlConnection connection)
        {
            count = 2;
            connection.ExecuteScalar<int>("sp_config_dynamic_DeleteRow", dynamicValues(row), commandType: CommandType.StoredProcedure);
        }

        private static DynamicParameters dynamicValues(FundingTypePeriodSheetType row)
        {
            var parameters = new DynamicParameters();
            if (processType != null)
            {
                parameters.Add("processType", processType);
                parameters.Add("schemaName", schemaName);
                parameters.Add("tableName", tableName);
                parameters.Add("param1", row.FundingTypeCode);
                parameters.Add("param2", row.FundingPeriod);
                parameters.Add("param3", row.FtpGroupCode);
                parameters.Add("param4", row.PrecedingFtpFundingType);
                parameters.Add("param5", row.PrecedingFtpFundingPeriod);
                parameters.Add("param6", row.IncludeAllContractsOnSummaryOfFunding);
                parameters.Add("param7", row.AllowNewAmendment);
                parameters.Add("param8", row.AllAmendmentsRequireSigning);
                parameters.Add("param9", row.ContractExpiryDate);
                parameters.Add("column1", columnFields[0]);
                parameters.Add("column2", columnFields[1]);
                parameters.Add("column3", columnFields[2]);
                parameters.Add("column4", columnFields[3]);
                parameters.Add("column5", columnFields[4]);
                parameters.Add("column6", columnFields[5]);
                parameters.Add("column7", columnFields[6]);
                parameters.Add("column8", columnFields[7]);
                parameters.Add("column9", columnFields[8]);
            }
            else
            {
                parameters.Add("count", count);
                parameters.Add("schemaName", schemaName);
                parameters.Add("tableName", tableName);
                parameters.Add("param1", row.FundingTypeCode);
                parameters.Add("param2", row.FundingPeriod);
                parameters.Add("column1", columnFields[0]);
                parameters.Add("column2", columnFields[1]);
            }
            return parameters;
        }
    }
}