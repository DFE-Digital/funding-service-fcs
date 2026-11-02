namespace SFA.FCT.Operations.Maintenance.Endpoint.Repositories
{
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.Threading.Tasks;
    using System.Linq;
    using Dapper;
    using FCS.Worker.Common;

    public class SchemaQueryRepository : ISchemaQueryRepository
    {
        private readonly IFcsConfiguration _configuration;

        public SchemaQueryRepository(IFcsConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<IReadOnlyCollection<string>> GetSchemaNamesWithProcessedMessageTable()
        {
            var connectionString = _configuration["ConnectionStrings:ContractManagementDbContext"];

            using (var connection = new SqlConnection(connectionString))
            {
                const string sqlQuery = "select table_schema from information_schema.tables where table_name = 'ProcessedMessage'";

                var schemaNames = await connection.QueryAsync<string>(sqlQuery).ConfigureAwait(continueOnCapturedContext: false);

                return schemaNames.ToList();
            }
        }
    }
}