namespace FundingAllocation.Services
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dto;

    public interface IConfigValidationService
    {
        Task<ConfigValidationResult> GetAwaitingConfigFilterResult(
            IReadOnlyCollection<FundingAllocationValidationInput> fundingValidationInputs);
    }
}