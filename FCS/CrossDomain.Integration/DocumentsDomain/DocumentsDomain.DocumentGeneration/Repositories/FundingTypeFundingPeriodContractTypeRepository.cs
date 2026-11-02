namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Repositories
{
    using ContractManagement.DataStore;
    using System;
    using System.Collections.Concurrent;
    using System.Linq;

    public class FundingTypeFundingPeriodContractTypeRepository : IFundingTypeFundingPeriodContractTypeRepository
    {
        private readonly IContractManagementDbContext _dbContractManagementDbContext;
        private static readonly ConcurrentDictionary<string, Lazy<string>> CachedContractTypeDefinedContractTermForProvider = new ConcurrentDictionary<string, Lazy<string>>();

        public FundingTypeFundingPeriodContractTypeRepository(IContractManagementDbContext dbContext)
        {
            _dbContractManagementDbContext = dbContext;
        }

        public string GetDefinedContractTermForProvider(string fundingTypeCode, string fundingPeriodCode, string contractType)
        {
            string key = $"{fundingTypeCode}__{fundingPeriodCode}__{contractType}";

            var lazyDefinedContractTermForProvider = new Lazy<string>(() => GetDefinedContractTermForProviderFromDb(fundingTypeCode, fundingPeriodCode, contractType));

            return CachedContractTypeDefinedContractTermForProvider.GetOrAdd(key, lazyDefinedContractTermForProvider).Value;
        }

        private string GetDefinedContractTermForProviderFromDb(string fundingTypeCode, string fundingPeriodCode, string contractType)
        {
            return  _dbContractManagementDbContext.FundingTypeFundingPeriodContractTypes.SingleOrDefault(ftfpct =>
                                                            ftfpct.FundingTypeCode == fundingTypeCode &&
                                                            ftfpct.FundingPeriodCode == fundingPeriodCode &&
                                                            ftfpct.ContractType == contractType)
                                                        ?.DefinedContractTermForProvider ?? string.Empty;
        }
    }
}