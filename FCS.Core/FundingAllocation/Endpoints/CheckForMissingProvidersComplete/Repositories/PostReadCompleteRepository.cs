namespace FundingAllocation.Endpoints.CheckForMissingProvidersComplete.Repositories
{
    using System.Threading.Tasks;
    using Dapper;
    using DataStore;
    using DataStore.Model;
    using Microsoft.EntityFrameworkCore;

    public class PostReadCompleteRepository : IPostReadCompleteRepository
    {
        private readonly FundingAllocationContext _fundingAllocationContext;

        public PostReadCompleteRepository(FundingAllocationContext fundingAllocationContext)
        {
            _fundingAllocationContext = fundingAllocationContext;
        }

        public async Task<bool> IsPostReadMissingProviderCheckComplete()
        {
            string parkedPending = FundingAllocationStatus.ParkedPending.ToString();
            string providerCheck = FundingAllocationSubStatus.ProviderCheck.ToString();

            var numStillPending = await _fundingAllocationContext.Database
                .GetDbConnection().ExecuteScalarAsync<int>(
                    "sp_FA_IsPostReadMissingProviderCheckComplete @parkedPending,@providerCheck", 
                    param: new { parkedPending, providerCheck },
                    transaction: _fundingAllocationContext.CurrentTransaction);

            return numStillPending == 0;
        }
    }
}
