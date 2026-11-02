using System.Collections.Generic;
using System.Threading.Tasks;

namespace ContractManagementService.Services
{
    public interface IFundingStreamPeriodCodeService
    {
        Task<IReadOnlyCollection<string>> GetFundingStreamPeriodCodesAsync(
            string allocationFundingStreamCode,
            string allocationPeriodCode);
    }
}
