namespace ContractManagementDomain.Endpoint.ContractApproved.Services
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IApprovedContractPopulateCacheService
    {
        Task UpdateApprovedContractCache(Contract corporateContract, string masterContractNumber, ConnectionInfo connectionInfo);
    }
}
