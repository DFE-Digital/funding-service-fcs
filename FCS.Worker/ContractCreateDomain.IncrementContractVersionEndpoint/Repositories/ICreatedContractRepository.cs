namespace ContractCreateDomain.IncrementContractVersionEndpoint.Repositories
{
    using System;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using Optional;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ICreatedContractRepository
    {
        Task Add(CreatedContract createdContract, ConnectionInfo connectionInfo);

        Task<Option<DateTime?>> GetLatestCreatedDateForNonNotificationApprovedContract(string contractNumber, ConnectionInfo connectionInfo);
    }
}