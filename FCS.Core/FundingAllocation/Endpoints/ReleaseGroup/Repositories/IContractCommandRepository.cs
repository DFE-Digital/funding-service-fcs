namespace FundingAllocation.Endpoints.ReleaseGroup.Repositories
{
    using System.Threading.Tasks;

    public interface IContractCommandRepository
    {
        Task<int> AddContract(string contractNumber, int version, int subVersion);
    }
}