namespace Operations.Web.Repositories
{
    using System.Threading.Tasks;
    using System;

    public interface IMonthEndRepository
    {
        Task<DateTime?> GetLatestEndTime();
    }
}