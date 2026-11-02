namespace FundingAllocation.Repositories
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using DataStore;
    using LanguageExt;
    using Microsoft.EntityFrameworkCore;

    public class ContractTypeRepository : IContractTypeRepository
    {
        private readonly FundingAllocationContext _context;

        public ContractTypeRepository(FundingAllocationContext context)
        {
            _context = context;
        }

        public async Task<string> GetContractType(string fundingTypeCode, string fundingPeriodCode,
            string providerCategory)
        {
            var contractTypeOption = await TryGetContractType(fundingTypeCode: fundingTypeCode,
                fundingPeriodCode: fundingPeriodCode,
                providerCategory: providerCategory);

            return contractTypeOption.Match(Some: ct => ct,
                None: () =>
                    throw new ArgumentException(
                        $"Contract Type not found for fundingTypeCode: {fundingTypeCode}, fundingPeriodCode: {fundingPeriodCode}, providerCategory: {providerCategory}"));
        }

        public async Task<Option<string>> TryGetContractType(string fundingTypeCode, string fundingPeriodCode,
            string providerCategory)
        {
            const string providerCategoryDefault = "DEFAULT";

            var matchingContractTypeRows = await _context.CfsCodesToContractTypeConfigRows.Where(
                    ct => ct.FundingTypeCode == fundingTypeCode &&
                          ct.FundingPeriodCode == fundingPeriodCode)
                .Select(ct => new { ct.ContractType, ct.ProviderCategory })
                .ToListAsync();

            var matchingContractTypeRow =
                matchingContractTypeRows.SingleOrDefault(ct => ct.ProviderCategory == providerCategory)
                ?? matchingContractTypeRows.SingleOrDefault(r => r.ProviderCategory == providerCategoryDefault);

            return matchingContractTypeRow?.ContractType;
        }
    }
}