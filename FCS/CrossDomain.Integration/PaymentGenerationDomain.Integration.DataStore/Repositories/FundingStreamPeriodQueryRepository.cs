namespace PaymentGenerationDomain.Integration.DataStore.Repositories
{
    using System;
    using System.Collections.Concurrent;
    using System.Data.Entity;
    using System.Threading.Tasks;
    using PaymentGenerationDomain.Integration.DataStore.Model;

    public class FundingStreamPeriodQueryRepository : IFundingStreamPeriodQueryRepository
    {
        private readonly PaymentGenerationDbContext _paymentGenerationDbContext;
        private static readonly ConcurrentDictionary<string, Lazy<Task<FundingStreamPeriod>>> CachedFundingStreamPeriods = new ConcurrentDictionary<string, Lazy<Task<FundingStreamPeriod>>>();

        public FundingStreamPeriodQueryRepository(PaymentGenerationDbContext paymentGenerationDbContext)
        {
            _paymentGenerationDbContext = paymentGenerationDbContext;
        }

        public async Task<FundingStreamPeriod> GetFundingStreamPeriodWithFundingStream(string fundingStreamPeriodCode)
        {
            Lazy<Task<FundingStreamPeriod>> lazyTaskGetFundingStreamPeriod = new Lazy<Task<FundingStreamPeriod>>(() => GetFundingStreamPeriodFromDb(fundingStreamPeriodCode));

            lazyTaskGetFundingStreamPeriod = CachedFundingStreamPeriods.GetOrAdd(fundingStreamPeriodCode, lazyTaskGetFundingStreamPeriod);

            return await lazyTaskGetFundingStreamPeriod.Value;
        }

        private Task<FundingStreamPeriod> GetFundingStreamPeriodFromDb(string fundingStreamPeriodCode)
        {
            return _paymentGenerationDbContext.FundingStreamPeriods
                .AsNoTracking()
                .Include(fsp => fsp.FundingStream)
                .SingleAsync(fsp => fsp.Code == fundingStreamPeriodCode);
        }
    }
}
