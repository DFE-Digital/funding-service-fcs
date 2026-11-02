namespace ContractCreateDomain.IncrementContractVersionEndpoint.Services
{
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using System.Collections.Generic;
    using System.Linq;
    using Extensions;
    using Repositories;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class SiblingApprovedContractService : ISiblingApprovedContractService
    {
        private readonly IApprovedContractRepository _approvedContractRepository;
        private readonly IFundingTypeFundingPeriodRepository _fundingTypeFundingPeriodRepository;

        public SiblingApprovedContractService(IApprovedContractRepository approvedContractRepository,
            IFundingTypeFundingPeriodRepository fundingTypeFundingPeriodRepository)
        {
            _approvedContractRepository = approvedContractRepository;
            _fundingTypeFundingPeriodRepository = fundingTypeFundingPeriodRepository;
        }

        public async Task<List<ApprovedContractInfo>> GetSiblingApprovedContractsForDocumentGeneration(
            string masterContractNumber,
            string currentContractNumber,
            string fundingTypeCode,
            string fundingPeriod, 
            ConnectionInfo connectionInfo)
        {
            var shouldIncludeAllContractsOnSummaryOfFunding = await _fundingTypeFundingPeriodRepository
                .ShouldIncludeAllContractsOnSummaryOfFunding(fundingTypeCode, fundingPeriod, connectionInfo)
                .ConfigureAwait(continueOnCapturedContext: false);

            if (shouldIncludeAllContractsOnSummaryOfFunding)
            {
                IReadOnlyCollection<ApprovedContract> approvedContracts = await _approvedContractRepository
                    .FindByMasterContractNumber(masterContractNumber, connectionInfo)
                    .ConfigureAwait(continueOnCapturedContext: false);

                return approvedContracts
                    .Where(ac => ac.ContractNumber != currentContractNumber)
                    .Select(ac => ac.ToApprovedContractInfo())
                    .ToList();
            }

            return Enumerable.Empty<ApprovedContractInfo>().ToList();
        }
    }
}