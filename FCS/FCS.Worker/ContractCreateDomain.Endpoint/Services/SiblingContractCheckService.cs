namespace ContractCreateDomain.Endpoint.Services
{
    using Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using Repositories;

    public class SiblingContractCheckService : ISiblingContractCheckService
    {
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;
        private readonly ICrmContractQueryRepository _crmContractQueryRepository;

        public SiblingContractCheckService(IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository, 
            ICrmContractQueryRepository crmContractQueryRepository)
        {
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
            _crmContractQueryRepository = crmContractQueryRepository;
        }

        public bool HasSiblingContractWithDraftStatus(string masterContractNumber, string contractNumber, string fundingTypeCode, string fundingPeriod, ConnectionInfo connectionInfo)
        {
            var includeAllContractsOnSummaryOfFunding = _fundingTypeFundingPeriodQueryRepository.Get(fundingTypeCode, fundingPeriod, connectionInfo).IncludeAllContractsOnSummaryOfFunding;

            if (includeAllContractsOnSummaryOfFunding)
            {
                return _crmContractQueryRepository.HasSiblingContractWithDraftStatus(masterContractNumber, contractNumber);
            }

            return false;
        }
    }
}