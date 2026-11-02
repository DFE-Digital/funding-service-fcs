namespace SFA.FCT.DocumentsDomain.DataStore.Repositories
{
    using System.Linq;
    using Models;

    public class ContractDocumentTemplateRepository : IContractDocumentTemplateRepository
    {
        private readonly DocumentsDomainDbContext _context;

        public ContractDocumentTemplateRepository(DocumentsDomainDbContext context)
        {
            _context = context;
        }

        public ContractDocumentTemplate GetByKey(string fundingTypeCode, string fundingPeriodCode, string documentComponentCode, string contractType)
        {
            return _context.ContractDocumentTemplates.Single(c => c.FundingTypeCode == fundingTypeCode
            && c.FundingPeriodCode == fundingPeriodCode
            && c.DocumentComponentCode == documentComponentCode
            && c.ContractType == contractType);
        }
    }
}