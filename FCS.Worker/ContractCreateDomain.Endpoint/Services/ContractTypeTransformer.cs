namespace ContractCreateDomain.Endpoint.Services
{
    using System.Linq;
    using AutoMapper;
    using Endpoint.Extensions;
    using ContractRequest = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using CorporateContract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public class ContractTypeTransformer : IContractTypeTransformer
    {
        public CorporateContract.contract TransformContractTypeToContract(CorporateContract.contractType contractType)
        {
            Mapper.CreateMap<CorporateContract.contractType, CorporateContract.contract>();

            var contract = Mapper.Map<CorporateContract.contractType, CorporateContract.contract>(contractType);
            contract.contracts.ForEach(c =>
            {
                var matchingCorpChildContract = contract.contracts.Single(corpChildContract => corpChildContract.contractNumber == c.contractNumber);

                c.contractAllocations.ForEach(a =>
                {
                    var matchingCorpAllocation = matchingCorpChildContract.contractAllocations.Single(corpAllocation =>
                        corpAllocation.contractAllocationNumber == a.contractAllocationNumber);

                    a.contractDeliverables = matchingCorpAllocation.contractDeliverables.Select(ToCorporateContractDeliverable).ToList();
                });
            });

            return contract;
        }

        public ContractRequest.contractType TransformCorpContractToContractRequest(CorporateContract.contractType contractType)
        {
            Mapper.CreateMap<CorporateContract.contractType, ContractRequest.contractType>();
            Mapper.CreateMap<CorporateContract.period, ContractRequest.periodType>();
            Mapper.CreateMap<CorporateContract.contractAllocationsContractAllocation, ContractRequest.contractAllocation>();
            Mapper.CreateMap<CorporateContract.contractDeliverablesTypeContractDeliverable, ContractRequest.contractDeliverable>();
            Mapper.CreateMap<CorporateContract.deliverableType, ContractRequest.deliverableType>();
            Mapper.CreateMap<CorporateContract.contractDeliverablesTypeContractDeliverable, ContractRequest.contractDeliverable>();
            Mapper
                .CreateMap<CorporateContract.contractDeliverablePeriodsTypeContractDeliverablePeriod,
                    ContractRequest.contractDeliverablePeriodType>();
            Mapper.CreateMap<CorporateContract.periodTypeType, ContractRequest.periodTypeType>();
            Mapper.CreateMap<CorporateContract.contractor, ContractRequest.contractor>();

            var contract = Mapper.Map<CorporateContract.contractType, ContractRequest.contractType>(contractType);
            contract.contractAllocations.ForEach(contractRequestAllocation =>
            {
                var corpContractAllocation = contractType.contractAllocations.Single(ca =>
                    ca.contractAllocationNumber == contractRequestAllocation.contractAllocationNumber);

                contractRequestAllocation.contractDeliverables = corpContractAllocation.GetAllDeliverables()
                    .Select(Mapper
                        .Map<CorporateContract.contractDeliverablesTypeContractDeliverable,
                            ContractRequest.contractDeliverable>).ToList();
            });
            
            return contract;
        }

        public CorporateContract.ExtendedContractType TransformContractTypeToExtendedContractType(CorporateContract.contractType contractType)
        {
            Mapper.CreateMap<CorporateContract.contractType, CorporateContract.ExtendedContractType>();
            Mapper.CreateMap<CorporateContract.contractAllocationsContractAllocation, CorporateContract.ExtendedContractAllocation>();

            var extendedContractType = Mapper.Map<CorporateContract.contractType, CorporateContract.ExtendedContractType>(contractType);

            extendedContractType.contracts.ForEach(c =>
            {
                var matchingCorpChildContract = extendedContractType.contracts.Single(corpChildContract => corpChildContract.contractNumber == c.contractNumber);

                c.contractAllocations.ForEach(a =>
                {
                    var matchingCorpAllocation = matchingCorpChildContract.contractAllocations.Single(corpAllocation =>
                        corpAllocation.contractAllocationNumber == a.contractAllocationNumber);

                    a.contractDeliverables = matchingCorpAllocation.contractDeliverables.Select(ToCorporateContractDeliverable).ToList();
                });
                c.TerminationReason = c.TerminationReason.HasValue() ? c.TerminationReason : null;
            });

            return extendedContractType;
        }

        private static CorporateContract.contractDeliverablesTypeContractDeliverable ToCorporateContractDeliverable(
            CorporateContract.contractDeliverablesTypeContractDeliverable deliverable)
        {
            return Mapper
                .Map<CorporateContract.contractDeliverablesTypeContractDeliverable,
                    CorporateContract.contractDeliverablesTypeContractDeliverable>(deliverable);
        }
    }
}
