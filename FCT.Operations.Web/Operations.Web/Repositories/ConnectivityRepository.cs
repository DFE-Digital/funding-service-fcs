namespace Operations.Web.Repositories
{
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using Dtos;

    public class ConnectivityRepository : IConnectivityRepository
    {
        public async Task<AvailabilityCheckResult> GetAvailabilityCheckResult(string serviceName)
        {
            var connectionString =
                ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            SqlConnection connection = new SqlConnection(connectionString);

            var rows = await connection.QueryAsync<dynamic>("dbo.sp_OpsWeb_GetAvailabilityCheckResult @serviceName", param: new { serviceName });

            return rows.Select(r => new AvailabilityCheckResult(serviceName, r.isAvailable)
            {
                Details = r.ErrorInfo,
                SupplementaryInfo = r.SupplementaryInfo
            }).Single();
        }
    }
}