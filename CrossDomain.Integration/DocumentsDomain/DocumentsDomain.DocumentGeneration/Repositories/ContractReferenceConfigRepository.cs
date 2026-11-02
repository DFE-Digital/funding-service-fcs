namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Repositories
{
    using System.Linq;
    using Optional;
    using DataStore;
    using DataStore.Models;

    public class ContractReferenceConfigRepository : IContractReferenceConfigRepository
    {
        private readonly DocumentsDomainDbContext _context;

        public ContractReferenceConfigRepository(DocumentsDomainDbContext context)
        {
            _context = context;
        }

        public Option<ContractReferenceConfig> GetContractReferenceConfig(int ukprn, string fundingStreamPeriodCode)
        {
            var entity = _context.ContractReferenceConfigs.SingleOrDefault(crc =>
                crc.Ukprn == ukprn && crc.FundingStreamPeriodCode == fundingStreamPeriodCode);

            return entity.SomeNotNull();
        }
    }
}