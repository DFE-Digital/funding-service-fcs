namespace Operations.Web.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dtos;

    public interface IContractAtomFeedQueryRepository
    {
        Task<IReadOnlyCollection<ContractAtomFeedInfo>> GetContracts(string contractNumber);
        Task<string> GetXmlForContract(int id);
        Task<IReadOnlyCollection<ContractCleanup>> GetContractData(List<string> fundingIds);
        Task<IReadOnlyCollection<ContractCleanup>> GetApprovedContractData(List<string> fundingIds);
        Task<bool> CleanupContractData(IReadOnlyCollection<ContractCleanup> contractsdata);
    }
}