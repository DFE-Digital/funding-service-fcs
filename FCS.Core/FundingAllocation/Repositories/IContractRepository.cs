namespace FundingAllocation.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dto;

    public interface IContractRepository
    {
        Task<IReadOnlyCollection<FundingAllocationInfo>> GetFundingAllocationInfosInContractControl(string contractNumber, int contractVersionNumber);

        Task DeleteContractIfOrphaned(string contractNumber, int contractVersionNumber, int contractSubversionNumber);

        Task<int> CreateContractWithQueuedRelationshipOrReturnExistingId(string contractNumber, int contractVersionNumber, int contractSubVersionNumber);
    }
}