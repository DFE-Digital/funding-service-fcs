namespace Operations.Web.Repositories
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using Dtos;

    public class ClosedCollectionRepository : IClosedCollectionRepository
    {
        public async Task<IReadOnlyCollection<ClosedCollection>> GetClosedCollectionsDesc(int startRow, int numRows)
        {
            string connectionString = ConfigurationManager
                .ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                var closedCollections = await connection.QueryAsync<ClosedCollection>(
                        "sp_OpsWeb_GetClosedCollectionsDesc @startRow,@numRows", new { startRow, numRows })
                    .ConfigureAwait(false);

                return closedCollections.ToList();
            }
        }
    }
}