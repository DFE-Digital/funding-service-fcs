namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using ExcelTypes;

    public static class ProviderCategoryExceptionWriter
    {
        public static async Task WriteToPaas(IEnumerable<ProviderCategoryException> rows, WriterBehaviour behaviour)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;


            using (var connection = new SqlConnection(connectionString))
            {
                var existingRows = await connection.GetAllRows();

                if (behaviour == WriterBehaviour.AddOrUpdate)
                {
                    var approvals = rows.Where(r => r.PolicyStatus == PolicyStatus.Approved).ToList();

                    await connection.ProcessRows("InsertSql", 
                        () => approvals.Where(a => !existingRows.Contains(a)));

                    await connection.ProcessRows("UpdateSql",
                        () => approvals.Where(a => existingRows.Any(r => r.Equals(a) && r.Category != a.Category)).ToList());
                }
                else
                {
                    var deletions = rows.Where(r => r.PolicyStatus == PolicyStatus.Removed);

                    await connection.ProcessRows("DeleteSql", 
                        () => deletions.Where(d => existingRows.Any(r => r.Equals(d) && r.Category == d.Category)));
                }
            }
        }

        private static async Task<IReadOnlyCollection<ProviderCategoryException>> GetAllRows(this IDbConnection connection)
        {
            const string sql = @"select * from [FundingAllocation].[ProviderCategoryException]";

            var items = await connection.QueryAsync<ProviderCategoryException>(sql);

            return items.ToList();
        }

        private static async Task ProcessRows(this IDbConnection connection, string processtype,
            Func<IEnumerable<ProviderCategoryException>> selector)
        {
            var rowsToProcess = selector().ToList();
            var param = new DynamicParameters();
            param.Add("rowsToProcess", getRowsToProcessTable(rowsToProcess).AsTableValuedParameter("RowsToProcessUDT"));
            param.Add("processtype", processtype);

            if (rowsToProcess.Any())
            {
                await connection.QueryAsync("sp_ProviderCategoryException_ProcessRows", param, commandType: CommandType.StoredProcedure);
            }
        }

        private static DataTable getRowsToProcessTable(List<ProviderCategoryException> rowsToProcess)
        {
            var rowsToProcessDT = new DataTable();
            rowsToProcessDT.Columns.Add("FundingTypeCode");
            rowsToProcessDT.Columns.Add("FundingPeriodCode");
            rowsToProcessDT.Columns.Add("UKPRN");
            rowsToProcessDT.Columns.Add("Category");
            foreach (var res in rowsToProcess)
            {
                rowsToProcessDT.Rows.Add(res.FundingTypeCode, res.FundingPeriodCode, res.UKPRN, res.Category);

            }
            return rowsToProcessDT;
        }
    }
}
