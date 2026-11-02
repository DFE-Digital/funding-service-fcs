namespace FundingAllocation.Repositories
{
    using System.Threading.Tasks;
    using LanguageExt;

    public interface IContractTypeRepository
    {
        Task<string> GetContractType(string fundingTypeCode, string fundingPeriodCode, string providerCategory);

        Task<Option<string>> TryGetContractType(string fundingTypeCode, string fundingPeriodCode,
            string providerCategory);
    }
}