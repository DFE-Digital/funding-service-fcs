namespace ContractCreateDomain.IncrementContractVersionEndpoint.Services
{
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System.Threading.Tasks;

    public interface ILevyContractAllocationService
    {
        Task AddPayableNonLevyContractAllocationIfNotPresent(ExtendedContractType childContract, ConnectionInfo connectionInfo);
    }
}