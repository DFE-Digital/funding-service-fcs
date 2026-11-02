namespace FundingAllocation.Repositories
{
    using System.Threading.Tasks;
    using LanguageExt;

    public interface IAllocationFundingStreamConfigRepository
    {
        Task<Option<(string FSPGroupCode, string FundingPeriodCode, string FundingTypeCode)>>
            TryGetAllocationFundingStreamConfig(
                string allocationFundingStreamCode, string allocationPeriodId);

        Task<(string FSPGroupCode, string FundingPeriodCode, string FundingTypeCode)>
            GetAllocationFundingStreamConfig(
                string allocationFundingStreamCode, string allocationPeriodId);
    }
}