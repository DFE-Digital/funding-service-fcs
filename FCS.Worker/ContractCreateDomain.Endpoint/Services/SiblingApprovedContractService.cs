namespace ContractCreateDomain.Endpoint.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using Extensions;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class SiblingApprovedContractService : ISiblingApprovedContractService
    {
        private readonly IApprovedContractRepository _approvedContractRepository;
        private readonly IFundingTypeFundingPeriodRepository _fundingTypeFundingPeriodRepository;

        public SiblingApprovedContractService(IApprovedContractRepository approvedContractRepository, IFundingTypeFundingPeriodRepository fundingTypeFundingPeriodRepository)
        {
            _approvedContractRepository = approvedContractRepository;
            _fundingTypeFundingPeriodRepository = fundingTypeFundingPeriodRepository;
        }

        public async Task<IReadOnlyCollection<ApprovedContractInfo>> GetSiblingApprovedContractsForDocumentGeneration(string masterContractNumber, string fundingTypeCode, string fundingPeriod, ConnectionInfo connectionInfo)
        {
            return await GetSiblingApprovedContractsForDocumentGeneration(masterContractNumber, null, fundingTypeCode, fundingPeriod, connectionInfo)
                .ConfigureAwait(false);
        }

        public async Task<IReadOnlyCollection<ApprovedContractInfo>> GetSiblingApprovedContractsForDocumentGeneration(string masterContractNumber, string currentContractNumber, string fundingTypeCode, string fundingPeriod, ConnectionInfo connectionInfo)
        {
            bool shouldIncludeAllContractsOnSummaryOfFunding = await _fundingTypeFundingPeriodRepository.ShouldIncludeAllContractsOnSummaryOfFunding(fundingTypeCode, fundingPeriod, connectionInfo)
                .ConfigureAwait(false);

            if (shouldIncludeAllContractsOnSummaryOfFunding)
            {
                IReadOnlyCollection<ApprovedContract> approvedContracts = await _approvedContractRepository.FindLatestByMasterContractNumber(masterContractNumber, connectionInfo).ConfigureAwait(false);

                return approvedContracts
                    .Where(ac => ac.ContractNumber != currentContractNumber)
                    .Select(ac => ac.ToApprovedContractInfo())
                    .ToList();
            }

            return Enumerable.Empty<ApprovedContractInfo>().ToList();
        }
    }
}