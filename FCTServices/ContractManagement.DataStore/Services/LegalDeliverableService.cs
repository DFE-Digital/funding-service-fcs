namespace ContractManagement.DataStore.Services
{
    using System.Collections.Generic;
    using ContractManagement.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using ContractRequest = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    public class LegalDeliverableService : ILegalDeliverableService
    {
        private readonly IFundingStreamPeriodLegalDeliverableRepository _fundingStreamPeriodLegalDeliverableRepository;

        public LegalDeliverableService(IFundingStreamPeriodLegalDeliverableRepository fundingStreamPeriodLegalDeliverableRepository)
        {
            _fundingStreamPeriodLegalDeliverableRepository = fundingStreamPeriodLegalDeliverableRepository;
        }

        public void RemoveNonLegalDeliverablesFromContract(Contract masterContract)
        {
            masterContract.contracts.ForEach(c =>
            {
                c.contractAllocations.ForEach(a =>
                {
                    IReadOnlyCollection<int> legalDeliverableCodes = _fundingStreamPeriodLegalDeliverableRepository.GetLegalDeliverablesForFsp(a.fundingStreamPeriodCode);

                    DeliverableRemovalService.RemoveNonMatchingDeliverablesFromAllocation(a, legalDeliverableCodes);
                });
            });
        }

        public void RemoveNonLegalDeliverablesFromContract(ConnectionInfo connectionInfo, Contract masterContract)
        {
            masterContract.contracts.ForEach(c =>
            {
                c.contractAllocations.ForEach(a =>
                {
                    IReadOnlyCollection<int> legalDeliverableCodes = _fundingStreamPeriodLegalDeliverableRepository.GetLegalDeliverablesForFsp(connectionInfo, a.fundingStreamPeriodCode);

                    DeliverableRemovalService.RemoveNonMatchingDeliverablesFromAllocation(a, legalDeliverableCodes);
                });
            });
        }

        public void RemoveNonLegalDeliverablesFromContractType(ConnectionInfo connectionInfo, ContractRequest.contractType masterContract)
        {
            masterContract.contracts.ForEach(c =>
            {
                c.contractAllocations.ForEach(a =>
                {
                    IReadOnlyCollection<int> legalDeliverableCodes = _fundingStreamPeriodLegalDeliverableRepository.GetLegalDeliverablesForFsp(connectionInfo, a.fundingStreamPeriodCode);

                    DeliverableRemovalService.RemoveNonMatchingDeliverablesFromAllocation(a, legalDeliverableCodes);
                });
            });
        }
    }
}
