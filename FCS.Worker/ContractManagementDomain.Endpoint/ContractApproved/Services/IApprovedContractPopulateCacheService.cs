namespace ContractManagementDomain.Endpoint.ContractApproved.Services
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IApprovedContractPopulateCacheService
    {
        Task UpdateApprovedContractCache(contract corporateContract, string masterContractNumber, ConnectionInfo connectionInfo);
    }
}
