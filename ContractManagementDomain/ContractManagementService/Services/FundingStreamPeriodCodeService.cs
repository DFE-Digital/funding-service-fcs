using System.Collections.Generic;
using System.Threading.Tasks;
using ContractManagementService.Repositories;

namespace ContractManagementService.Services
{
    public class FundingStreamPeriodCodeService(IAllocationFundingStreamPeriodCodeQueryRepository repository)
        : IFundingStreamPeriodCodeService
    {
        private static readonly IReadOnlyDictionary<string, string[]> FundingStreamMappings =
            new Dictionary<string, string[]>(System.StringComparer.Ordinal)
            {
                ["ALL"] = ["LOANS", "ALLC", "ALLF", "ALLB"],
                ["ASF"] = ["ASFG", "ASFC", "ASCA"]
            };

        public Task<IReadOnlyCollection<string>> GetFundingStreamPeriodCodesAsync(
            string allocationFundingStreamCode,
            string allocationPeriodCode)
        {
            var fundingStreamCodes = FundingStreamMappings.TryGetValue(allocationFundingStreamCode, out var mappedCodes)
                ? mappedCodes
                : new[] { allocationFundingStreamCode };

            return repository.GetFundingStreamPeriodCodesAsync(fundingStreamCodes, allocationPeriodCode);
        }
    }
}
