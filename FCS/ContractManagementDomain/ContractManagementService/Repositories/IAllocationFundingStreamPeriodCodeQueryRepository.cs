using System.Collections.Generic;
using System.Threading.Tasks;

namespace ContractManagementService.Repositories
{
    public interface IAllocationFundingStreamPeriodCodeQueryRepository
    {
        Task<IReadOnlyCollection<string>> GetFundingStreamPeriodCodesAsync(
            IReadOnlyCollection<string> allocationFundingStreamCodes,
            string allocationPeriodCode);
    }
}
