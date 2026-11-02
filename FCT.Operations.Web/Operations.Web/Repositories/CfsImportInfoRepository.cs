namespace Operations.Web.Repositories
{
    using System.Threading.Tasks;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using Dtos;

    public class CfsImportInfoRepository : ICfsImportInfoRepository
    {
        public async Task<IReadOnlyCollection<CfsImportInfo>> GetCfsImportInfos(int startRow, int numRows)
        {
            string connectionString = ConfigurationManager
                .ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                var cfsImportInfos = await connection.QueryAsync<CfsImportInfo>(
                        "dbo.sp_OpsWeb_GetCfsImportInfos @startRow,@numRows", new { startRow, numRows })
                    .ConfigureAwait(false);

                return cfsImportInfos.ToList();
            }
        }
    }
}