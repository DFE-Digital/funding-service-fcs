namespace Operations.Web.Repositories
{
    using System.Threading.Tasks;
    using System;

    public interface IFundingTypeFundingPeriodRepository
    {
        Task<DateTime> GetLevyDefaultContractStartDate();
    }
}