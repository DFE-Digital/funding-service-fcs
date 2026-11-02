namespace ContractCreateDomain.Endpoint.Services
{
    using System;
    using System.Threading.Tasks;
    using Dapper;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using ContractManagement.DataStore.Model;

    public class LastApprovedContractCreationDateService : ILastApprovedContractCreationDateService
    {
        public async Task<DateTime?> GetLatestCreatedDateForNonNotificationApprovedContract(string contractNumber, ConnectionInfo connectionInfo)
        {
            const AmendmentType notificationAmendmentType = AmendmentType.Notification;
           

            return await connectionInfo.Connection.ExecuteScalarAsync<DateTime?>
                    ("sp_Worker_GetLatestCreatedDateforApproveContract @contractNumber,@notificationAmendmentType", new { contractNumber, notificationAmendmentType }, transaction: connectionInfo.Transaction)
                .ConfigureAwait(false);
        }
    }
}