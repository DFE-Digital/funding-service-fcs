namespace Operations.Web.Repositories
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Threading.Tasks;
    using Dapper;
    using ContractManagement.DataStore;
    using System.Linq;
    using System.Data.Entity;
    public class FundingTypeFundingPeriodRepository : IFundingTypeFundingPeriodRepository
    {
        private readonly Lazy<Task<DateTime>> _lazyCachedStartDate = new Lazy<Task<DateTime>>(GetLevyDefaultContractStartDateFromDb);

        public async Task<DateTime> GetLevyDefaultContractStartDate()
        {
            return await _lazyCachedStartDate.Value;
        }

        private static async Task<DateTime> GetLevyDefaultContractStartDateFromDb()
        {
            using (var context = new ContractManagementDbContext())
            {
                var result = await (from res in context.FundingTypeFundingPeriodItems.Where(ftfp =>
                ftfp.FundingTypeCode == "LEVY"
                && ftfp.FundingPeriodName == "LEVY1799")
                                    select res.DefaultContractStartDate).FirstAsync();
                return (DateTime)result;
            }

        }
    }
}