namespace FundingAllocation.Endpoints.DocumentGenerationComplete.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;

    public interface IContractRepository
    {
        Task<IReadOnlyCollection<string>> GetFundingAllocationIdsForContract(
            string contractNumber,
            int version,
            int subVersion);

        Task SetContractCreatedInCrmFlag(string contractNumber,
            int version,
            int subVersion);
    }
}