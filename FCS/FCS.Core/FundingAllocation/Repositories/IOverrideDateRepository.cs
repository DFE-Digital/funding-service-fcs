namespace FundingAllocation.Repositories
{
    using System;
    using System.Threading.Tasks;

    public interface IOverrideDateRepository
    {
        Task<DateTime> GetDate();
    }
}