namespace FundingAllocation.Repositories
{
    using System;
    using System.Threading.Tasks;

    public class SystemDateRepository : IOverrideDateRepository
    {
        public Task<DateTime> GetDate()
        {
            return Task.FromResult(DateTime.Now);
        }
    }
}
