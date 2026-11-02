namespace FundingAllocation.Services
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dto;

    public interface INonMaterialCheckService
    {
        Task<FilterCheckResult> GetFilterCheckResult(IReadOnlyCollection<string> fundingIds);
        Task<FilterCheckResult> GetLoanFilterCheckResult(IReadOnlyCollection<string> fundingIds);
    }
}