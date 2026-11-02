namespace SFA.FCT.DocumentsDomain.DataStore.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using Models;

    public class FspDeliverableRepository : IFspDeliverableRepository
    {
        private readonly DocumentsDomainDbContext _documentsDomainDbContext;

        public FspDeliverableRepository(DocumentsDomainDbContext documentsDomainDbContext)
        {
            _documentsDomainDbContext = documentsDomainDbContext;
        }

        public FSPDeliverable GetFspDeliverable(string fspCode, int deliverableCode)
        {
            return _documentsDomainDbContext.FSPDeliverables.Find(deliverableCode, fspCode);
        }

        public IReadOnlyCollection<FSPDeliverable> GetFspDeliverablesForFundingStreamPeriod(string fspCode)
        {
            return _documentsDomainDbContext.FSPDeliverables
                .Where(fspd => fspd.FundingStreamPeriodCode == fspCode)
                .ToList();
        }
    }
}