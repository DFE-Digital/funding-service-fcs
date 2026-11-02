namespace SFA.FCT.Operations.Maintenance.Endpoint.Repositories
{
    using System;
    using System.Threading.Tasks;
    using Dapper;
    using CrossDomain.Integration.Entities.Data;

    public class CrmReplicaRowDeleteRepository : ICrmReplicaRowDeleteRepository
    {
        public async Task DeleteContactDeliverablePeriodsForContractId(Guid contractId, ConnectionInfo connectionInfo)
        {

            await ExecuteSql("sp_Operations_DeleteContactDeliverablePeriodsForContractId @contractId",contractId, connectionInfo);
        }

        public async Task DeleteContactDeliverablesForContractId(Guid contractId, ConnectionInfo connectionInfo)
        {

            await ExecuteSql("sp_Operations_DeleteContactDeliverablesForContractId @contractId", contractId, connectionInfo);
        }

        public async Task DeleteContactAllocationsForContractId(Guid contractId, ConnectionInfo connectionInfo)
        {

            await ExecuteSql("sp_Operations_DeleteContactAllocationsForContractId @contractId", contractId, connectionInfo);
        }

        public async Task DeleteContactForContractId(Guid contractId, ConnectionInfo connectionInfo)
        {
            const string sql = @"delete from [dbo].[sfa_contract] 
                                where Id = @contractId";

            await ExecuteSql(sql, contractId, connectionInfo);
        }

        private static async Task ExecuteSql(string sql, Guid contractId, ConnectionInfo connectionInfo)
        {
            await connectionInfo.Connection.ExecuteAsync(sql, new { contractId }, transaction: connectionInfo.Transaction)
                .ConfigureAwait(continueOnCapturedContext: false);
        }
    }
}
