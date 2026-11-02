namespace FundingAllocation.Repositories
{
    using System.Threading.Tasks;
    using LanguageExt;

    public interface IProviderCategoryRepository
    {
        Task<string> GetProviderCategoryExceptionOrDefault(string providerType, string providerSubType,
            string fundingTypeCode, string fundingPeriodCode, string ukprn);

        Task<Option<string>> TryGetProviderCategoryExceptionOrDefault(
            string providerType, string providerSubType,
            string fundingTypeCode, string fundingPeriodCode, string ukprn);
    }
}