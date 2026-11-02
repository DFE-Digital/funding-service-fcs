namespace ContractCreateDomain.Endpoint.Services
{
    using System;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ILastApprovedContractCreationDateService
    {
        Task<DateTime?> GetLatestCreatedDateForNonNotificationApprovedContract(string contractNumber, ConnectionInfo connectionInfo);
    }
}
