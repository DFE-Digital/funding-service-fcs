namespace FundingAllocation.Endpoints.ReleaseGroup.Repositories
{
    using System.Threading.Tasks;
    using DataStore;
    using DataStore.Model;

    public class ContractCommandRepository : IContractCommandRepository
    {
        private readonly FundingAllocationContext _fundingAllocationContext;

        public ContractCommandRepository(FundingAllocationContext fundingAllocationContext)
        {
            _fundingAllocationContext = fundingAllocationContext;
        }

        public async Task<int> AddContract(string contractNumber, int version, int subVersion)
        {
            var contract = new Contract(contractNumber, version, subVersion);
            
            await _fundingAllocationContext.Contracts.AddAsync(contract);

            await _fundingAllocationContext.SaveChangesAsync();

            return contract.Id;
        }
    }
}
