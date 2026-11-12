using System.Linq;
using AutoMapper;
using ContractRequest = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
using CorporateContract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

namespace ContractCreateDomain.Endpoint.Services
{
    public class ContractTypeTransformer : IContractTypeTransformer
    {
        private readonly IMapper _mapper;

        public ContractTypeTransformer(IMapper mapper)
        {
            _mapper = mapper;
        }

        public CorporateContract.Contract TransformContractTypeToContract(
            CorporateContract.contractType contractType)
        {
            var contract =
                _mapper.Map<CorporateContract.Contract>(contractType);

            contract.contracts.ForEach(c =>
            {
                var matchingCorpChildContract =
                    contract.contracts.Single(cc =>
                        cc.contractNumber == c.contractNumber);

                c.contractAllocations.ForEach(a =>
                {
                    var matchingCorpAllocation =
                        matchingCorpChildContract.contractAllocations.Single(ca =>
                            ca.contractAllocationNumber ==
                            a.contractAllocationNumber);

                    a.contractDeliverables =
                        matchingCorpAllocation.contractDeliverables
                            .Select(ToCorporateContractDeliverable)
                            .ToList();
                });
            });

            return contract;
        }

        public ContractRequest.contractType TransformCorpContractToContractRequest(
            CorporateContract.contractType contractType)
        {
            var contract =
                _mapper.Map<ContractRequest.contractType>(contractType);

            contract.contractAllocations.ForEach(crAllocation =>
            {
                var corpContractAllocation =
                    contractType.contractAllocations.Single(ca =>
                        ca.contractAllocationNumber ==
                        crAllocation.contractAllocationNumber);

                crAllocation.contractDeliverables =
                    corpContractAllocation.GetAllDeliverables()
                        .Select(d =>
                            _mapper.Map<ContractRequest.contractDeliverable>(d))
                        .ToList();
            });

            return contract;
        }

        public CorporateContract.ExtendedContractType
            TransformContractTypeToExtendedContractType(
                CorporateContract.contractType contractType)
        {
            var extended =
                _mapper.Map<CorporateContract.ExtendedContractType>(contractType);

            extended.contracts.ForEach(c =>
            {
                var matchingCorpChildContract =
                    extended.contracts.Single(cc =>
                        cc.contractNumber == c.contractNumber);

                c.contractAllocations.ForEach(a =>
                {
                    var matchingCorpAllocation =
                        matchingCorpChildContract.contractAllocations.Single(ca =>
                            ca.contractAllocationNumber ==
                            a.contractAllocationNumber);

                    a.contractDeliverables =
                        matchingCorpAllocation.contractDeliverables
                            .Select(ToCorporateContractDeliverable)
                            .ToList();
                });

                c.TerminationReason =
                    !string.IsNullOrWhiteSpace(c.TerminationReason)
                        ? c.TerminationReason
                        : null;

            });

            return extended;
        }

        private CorporateContract.contractDeliverablesTypeContractDeliverable
            ToCorporateContractDeliverable(
                CorporateContract.contractDeliverablesTypeContractDeliverable deliverable)
        {
            return _mapper.Map<
                CorporateContract.contractDeliverablesTypeContractDeliverable>(deliverable);
        }
    }
}
