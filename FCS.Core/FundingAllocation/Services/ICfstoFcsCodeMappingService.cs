namespace FundingAllocation.Services
{
    using System.Collections.Generic;
    using Dto;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public interface ICfsToFcsCodeMappingService
    {
        Task<FspCodeDeliverable> GetFspCodeDeliverable(ProviderFundingInfo providerFundingInfo);

        Task<ContractItemsMappingResult> GetContractItemsMappingResult(ContractItemsMappingInput mappingInput);

        Task<IReadOnlyCollection<LogicalAllocationInfo>> GetLogicalAllocations(
            IEnumerable<DataStore.Model.FundingAllocation> fundingAllocations);
    }
}