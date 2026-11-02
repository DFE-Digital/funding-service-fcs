namespace ContractCreateDomain.Endpoint.Services.Repositories
{
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ICreatedContractRepository
    {
        Task Add(CreatedContract createdContract, ConnectionInfo connectionInfo);
    }
}
