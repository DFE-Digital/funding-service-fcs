namespace ContractCreateDomain.IncrementContractVersionEndpoint.Repositories
{
    using System;
    using System.Threading.Tasks;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using Dapper;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using Optional;

    public class CreatedContractRepository : ICreatedContractRepository
    {
        public async Task Add(CreatedContract createdContract, ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                context.CreatedContracts.Add(createdContract);

                await context.SaveChangesAsync()
                    .ConfigureAwait(false);
            }
        }

        public async Task<Option<DateTime?>> GetLatestCreatedDateForNonNotificationApprovedContract(string contractNumber, ConnectionInfo connectionInfo)
        {
            const AmendmentType notificationAmendmentType = AmendmentType.Notification;           

            var mostRecentDate = await connectionInfo.Connection.ExecuteScalarAsync<DateTime?>
                ("sp_Worker_GetLatestCreatedDateforApproveContract @contractNumber,@notificationAmendmentType", new {contractNumber, notificationAmendmentType }, transaction: connectionInfo.Transaction)
                .ConfigureAwait(false);

            return mostRecentDate.SomeWhen(d => d != null);
        }
    }
}
