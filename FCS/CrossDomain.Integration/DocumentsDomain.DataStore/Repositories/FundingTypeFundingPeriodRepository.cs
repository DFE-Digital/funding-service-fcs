namespace SFA.FCT.DocumentsDomain.DataStore.Repositories
{
    using System.Collections.Concurrent;
    using System.Linq;
    using Models;

    public class FundingTypeFundingPeriodRepository : IFundingTypeFundingPeriodRepository
    {
        private static readonly ConcurrentDictionary<string, FundingTypeFundingPeriod> FundingTypeFundingPeriods = new ConcurrentDictionary<string, FundingTypeFundingPeriod>();
        private readonly DocumentsDomainDbContext _documentsDomainDbContext;

        public FundingTypeFundingPeriodRepository(DocumentsDomainDbContext documentsDomainDbContext)
        {
            _documentsDomainDbContext = documentsDomainDbContext;
        }

        public FundingTypeFundingPeriod Get(string fundingTypeCode, string fundingPeriodCode)
        {
            return FundingTypeFundingPeriods.GetOrAdd(CreateDictionaryKey(fundingTypeCode, fundingPeriodCode),
                key => GetFromDb(fundingTypeCode, fundingPeriodCode));
        }

        private FundingTypeFundingPeriod GetFromDb(string fundingTypeCode, string fundingPeriodCode)
        {
            return _documentsDomainDbContext.FundingTypeFundingPeriods
                .Single(ftfp => ftfp.FundingTypeCode == fundingTypeCode && ftfp.FundingPeriodName == fundingPeriodCode);
        }

        private string CreateDictionaryKey(string fundingTypeCode, string fundingPeriodCode)
        {
            return $"{fundingTypeCode}__{fundingPeriodCode}";
        }
    }
}
