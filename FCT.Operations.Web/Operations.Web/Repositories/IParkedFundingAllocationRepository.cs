namespace Operations.Web.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dtos;

    public interface IParkedFundingAllocationRepository
    {
        Task<IReadOnlyCollection<ParkedFundingAllocationsSubStatusInfo>> GetSubStatusCounts();
        Task<IReadOnlyCollection<AwaitingProviderInfo>> GetAwaitingProviderDetails();
        Task<IReadOnlyCollection<AwaitingFundingLineInfo>> GetAwaitingFundingLineDetails();
        Task<IReadOnlyCollection<AwaitingFundingAllocationInfo>> GetAwaitingFundingAllocationDetails();
        Task<IReadOnlyCollection<AwaitingContractTypeInfo>> GetAwaitingContractTypeDetails();
        Task<IReadOnlyCollection<ProviderTypeSubtypeInfo>> GetUnknownProviderTypeSubtypeDetails();
    }
}