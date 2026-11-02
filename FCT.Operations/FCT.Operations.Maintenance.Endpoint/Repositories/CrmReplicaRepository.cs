namespace SFA.FCT.Operations.Maintenance.Endpoint.Repositories
{
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.Threading.Tasks;
    using System.Linq;
    using Dapper;
    using FCS.Worker.Common;

    public class CrmReplicaRepository : ICrmReplicaRepository
    {
        private readonly IFcsConfiguration _configuration;

        public CrmReplicaRepository(IFcsConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<IReadOnlyCollection<ContractReplicationFailure>> GetContractReplicationFailures()
        {
            var connectionString = _configuration["ConnectionStrings:CrmDatabaseConnectionString"];

            using (var connection = new SqlConnection(connectionString))
            {
                var contractReplicationFailures = await connection.QueryAsync<ContractReplicationFailure>("sp_Operations_GetContractReplicationFailures")
                    .ConfigureAwait(continueOnCapturedContext: false);

                return contractReplicationFailures.ToList();
            }
        }
    }
}
