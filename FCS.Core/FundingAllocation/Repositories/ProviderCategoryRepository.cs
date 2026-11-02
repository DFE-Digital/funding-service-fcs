namespace FundingAllocation.Repositories
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using DataStore;
    using LanguageExt;
    using Microsoft.EntityFrameworkCore;
    using static LanguageExt.Prelude;

    public class ProviderCategoryRepository : IProviderCategoryRepository
    {
        private readonly FundingAllocationContext _context;

        public ProviderCategoryRepository(FundingAllocationContext context)
        {
            _context = context;
        }

        public async Task<string> GetProviderCategoryExceptionOrDefault(string providerType, string providerSubType,
            string fundingTypeCode, string fundingPeriodCode, string ukprn)
        {
            var providerCategoryExceptionOption =
                await GetProviderCategoryException(fundingTypeCode, fundingPeriodCode, ukprn);

            return await providerCategoryExceptionOption.Match(Some: Task.FromResult,
                None: () => GetProviderCategory(providerType, providerSubType));
        }

        public async Task<Option<string>> TryGetProviderCategoryExceptionOrDefault(
            string providerType, string providerSubType,
            string fundingTypeCode, string fundingPeriodCode, string ukprn)
        {
            var providerCategoryExceptionOption =
                await GetProviderCategoryException(fundingTypeCode, fundingPeriodCode, ukprn);

            return await providerCategoryExceptionOption.Match(Some: c => Task.FromResult(Some(c)),
                None: () => TryGetProviderCategory(providerType, providerSubType));
        }

        private async Task<string> GetProviderCategory(string providerType, string providerSubType)
        {
            var providerCategoryOption = await TryGetProviderCategory(providerType, providerSubType);

            return providerCategoryOption.Match(Some: c => c,
                None: () => throw new ArgumentException(
                    $"Provider Category not found providerType: {providerType}, providerSubType: {providerSubType}"));
        }

        private async Task<Option<string>> TryGetProviderCategory(string providerType, string providerSubType)
        {
            var providerCategories = await (from res in _context.ProviderTypeConfigRows
                                            where res.Type == providerType
                                            && res.Subtype == providerSubType
                                            select res.Category).SingleOrDefaultAsync();
            //const string sql =
            //    @"SELECT [Category]
            //      FROM [FundingAllocation].[ProviderTypeConfig]
            //      WHERE [Type] = @ProviderType
            //      AND [Subtype] = @ProviderSubType";

            //var providerCategories = await _context.Database.GetDbConnection().QueryAsync<string>(sql, new { providerType, providerSubType },
            //    transaction: _context.CurrentTransaction);
            //var providerCategoriesList = providerCategories.ToList();

            return providerCategories;
        }

        private async Task<Option<string>> GetProviderCategoryException(string fundingTypeCode, string fundingPeriodCode, string ukprn)
        {
            var providerCategories = await (from res in _context.ProviderCategoryExceptions
                                where res.FundingTypeCode == fundingTypeCode
                                && res.FundingPeriodCode == fundingPeriodCode
                                && res.UKPRN == ukprn
                                select res.Category).SingleOrDefaultAsync();
            //const string sql =
            //    @"SELECT [Category]
            //      FROM [FundingAllocation].[ProviderCategoryException]
            //      WHERE [FundingTypeCode] = @fundingTypeCode
            //      AND [FundingPeriodCode] = @fundingPeriodCode
            //      AND [UKPRN] = @ukprn";

            //var providerCategories = await _context.Database.GetDbConnection().QueryAsync<string>(sql, new { fundingTypeCode, fundingPeriodCode, ukprn },
            //    transaction: _context.CurrentTransaction);

            return providerCategories;
        }
    }
}
