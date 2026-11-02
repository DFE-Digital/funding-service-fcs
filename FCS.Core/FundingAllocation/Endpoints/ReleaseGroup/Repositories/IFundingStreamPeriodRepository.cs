namespace FundingAllocation.Endpoints.ReleaseGroup.Repositories
{
    using System;
    using System.Threading.Tasks;

    public interface IFundingStreamPeriodRepository
    {
        Task<(DateTime startDate, DateTime endDate)> GetFspStartAndEndDate(string fspCode);
    }
}