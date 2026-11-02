namespace SFA.FCT.DocumentsDomain.DataStore.Repositories
{
    using System.Linq;
    using Models;
    using System.Collections.Concurrent;

    public class FspGroupDocumentTemplateRepository : IFspGroupDocumentTemplateRepository
    {
        private readonly DocumentsDomainDbContext _context;

        private static readonly ConcurrentDictionary<string, FspGroupDocumentTemplate> CachedFspGroupDocumentTemplate =
            new ConcurrentDictionary<string, FspGroupDocumentTemplate>();

        public FspGroupDocumentTemplateRepository(DocumentsDomainDbContext context)
        {
            _context = context;
        }

        public FspGroupDocumentTemplate GetByKeyOrUseDefaultForContractType(
            string fundingTypeCode, string fundingPeriodCode, string documentComponentCode,
            string contractType, string fspGroupCode)
        {
            var keyAggregatedParameters = $"{fundingTypeCode}__{fundingPeriodCode}__{documentComponentCode}__{contractType}__{fspGroupCode}";

            return CachedFspGroupDocumentTemplate.GetOrAdd(keyAggregatedParameters,  
                _ => GetFspGroupDocumentTemplateFromDb(
                    fundingTypeCode, fundingPeriodCode, documentComponentCode,
                    contractType, fspGroupCode));
        }


        private FspGroupDocumentTemplate GetFspGroupDocumentTemplateFromDb(
            string fundingTypeCode, string fundingPeriodCode, string documentComponentCode,
            string contractType, string fspGroupCode)
        {
            var fspGroupDocumentTemplates = _context.FspGroupDocumentTemplates.Where(c => c.FundingTypeCode == fundingTypeCode
                                                                                          && c.FundingPeriodCode == fundingPeriodCode
                                                                                          && c.DocumentComponentCode == documentComponentCode
                                                                                          && c.FSPGroupCode == fspGroupCode).ToList();

            var matchedByContractType = fspGroupDocumentTemplates.FirstOrDefault(t => t.ContractType == contractType);

            if (matchedByContractType != null)
            {
                return matchedByContractType;
            }

            return fspGroupDocumentTemplates.First(t => t.ContractType == "DEFAULT");
        }
    }
}
