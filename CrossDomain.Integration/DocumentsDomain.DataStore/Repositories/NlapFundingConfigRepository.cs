namespace SFA.FCT.DocumentsDomain.DataStore.Repositories
{
    using System.Linq;
    using Models;
    using Optional;

    public class NlapFundingConfigRepository : INlapFundingConfigRepository
    {
        private readonly DocumentsDomainDbContext _context;

        public NlapFundingConfigRepository(DocumentsDomainDbContext context)
        {
            _context = context;
        }

        public Option<NlapFundingConfig> FindByUkprn(int ukprn)
        {
            NlapFundingConfig entity = _context.NlapFundingConfigs.SingleOrDefault(n => n.Ukprn == ukprn);

            return entity.SomeNotNull();
        }
    }
}