namespace ContractCreateDomain.Endpoint.Services
{
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using Repositories;
    using System.Linq;
    using Optional;
    using System;
    using DTOs;
    using CorporateContract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public class CheckForContractChangeService : ICheckForContractChangeService
    {
        private readonly ICheckForAllocationChangeService _checkForAllocationChangeService;
        private readonly ICrmContractQueryRepository _crmContractQueryRepository;

        public CheckForContractChangeService(ICheckForAllocationChangeService checkForAllocationChangeService, ICrmContractQueryRepository crmContractQueryRepository)
        {
            _checkForAllocationChangeService = checkForAllocationChangeService;
            _crmContractQueryRepository = crmContractQueryRepository;
        }

        public void UpdateAllocationsThatHaveBeenAddedOrChangedService(contractType mergedContract)
        {
            mergedContract.contracts.ToList().ForEach(childMergedContract =>
            {
                Option<CrmContract> crmContract = _crmContractQueryRepository.GetApprovedContract(childMergedContract.contractNumber);

                crmContract.MatchSome(crmContractInfo =>
                    _checkForAllocationChangeService.UpdateAllocationsThatHaveChangedOrBeenAdded(crmContractInfo, childMergedContract));

                crmContract.MatchNone(() => 
                    throw new ArgumentException($"Crm does not have an approved contract for contract number: {childMergedContract.contractNumber}"));
            });
        }

        public void UpdateCorpContractAllocations(CorporateContract.contractType corpContract,
            contractType contractRequest)
        {
            contractRequest.contractAllocations.ForEach(contractRequestAllocation =>
            {
                var matchingCorpAllocation = corpContract.contractAllocations.Single(ca =>
                    ca.contractAllocationNumber == contractRequestAllocation.contractAllocationNumber);

                matchingCorpAllocation.HasBeenAddedOrUpdated = contractRequestAllocation.HasBeenAddedOrUpdated;
                matchingCorpAllocation.HasBeenAdded = contractRequestAllocation.HasBeenAdded;
            });
        }
    }
}