namespace SFA.FCT.ContractManagementService.Common
{

    using System;
    using System.Linq;
    using AutoMapper;
    using CorporateContractContract = CrossDomain.Integration.Entities.CorporateContract;
    using CorporateSchemaContract = CrossDomain.Integration.Entities.CorporateSchema.Contract;
    public class ContractTransformer : IContractTransformer
    {
        private const string SBDFundingType = "SBD";

        private readonly IMapper _mapper;
        public ContractTransformer() : this(MapperProvider.Instance) { }
        public ContractTransformer(IMapper mapper)
        {
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
        }

        public CorporateSchemaContract.Contract TransformToCorporateSchemaContract(
            CorporateContractContract.Contract contract)
        {
            if (contract == null)
                return null;
            var corporateSchemaContract = _mapper.Map<
                CorporateContractContract.Contract,
                CorporateSchemaContract.Contract>(contract);

            corporateSchemaContract.contracts.ForEach(c =>
            {
                var matchingChild =
                    contract.contracts.Single(child =>
                        child.contractNumber == c.contractNumber);

                c.contractAllocations.ForEach(a =>
                {
                    var matchingAllocation =
                        matchingChild.contractAllocations.Single(alloc =>
                            alloc.contractAllocationNumber == a.contractAllocationNumber);

                    if (c.fundingType.fundingTypeCode == SBDFundingType)
                    {
                        a.ProcurementAttrs.TenderSpecReference = GetNullableString(a.ProcurementAttrs.TenderSpecReference);
                        a.ProcurementAttrs.AgreementNumber = Get11DigitString(a.ProcurementAttrs.AgreementNumber);
                        a.ProcurementAttrs.RegionType = GetNullableString(a.ProcurementAttrs.RegionType);
                        a.ProcurementAttrs.LEPName = GetNullableString(a.ProcurementAttrs.LEPName);
                        a.ProcurementAttrs.LEPCode = GetNullableString(a.ProcurementAttrs.LEPCode);
                        a.ProcurementAttrs.InvestmentPriority = GetNullableString(a.ProcurementAttrs.InvestmentPriority);
                        a.ProcurementAttrs.ActivityDescription = GetNullableString(a.ProcurementAttrs.ActivityDescription);
                        a.ProcurementAttrs.AwardReference = GetNullableString(a.ProcurementAttrs.AwardReference);
                        a.ProcurementAttrs.TenderSpecTitle = GetNullableString(a.ProcurementAttrs.TenderSpecTitle);
                    }

                   
                    a.contractDeliverables =
                        matchingAllocation.contractDeliverables
                            .Select(ToCorporateSchemaDeliverable)
                            .ToList();
                });
            });

         
            PopulateTerminationAttrsIfPresent(corporateSchemaContract, contract);

            return corporateSchemaContract;
        }

        public CorporateSchemaContract.contractDeliverablesTypeContractDeliverable
            ToCorporateSchemaDeliverable(
                CorporateContractContract.contractDeliverablesTypeContractDeliverable deliverable)
        {
            if (deliverable == null)
                return null;

            return _mapper.Map<
                CorporateContractContract.contractDeliverablesTypeContractDeliverable,
                CorporateSchemaContract.contractDeliverablesTypeContractDeliverable>(deliverable);
        }
        private static void PopulateTerminationAttrsIfPresent(
            CorporateSchemaContract.Contract corporateSchemaContract,
            CorporateContractContract.Contract contract)
        {
            var schemaChildren = corporateSchemaContract.contracts;

            contract.contracts.ForEach(dtoChild =>
            {
                var schemaChild =
                    schemaChildren.Single(sc =>
                        sc.contractNumber == dtoChild.contractNumber);

                schemaChild.TerminationContractAttrs.terminationDate =
                    dtoChild.TerminationDate;

                if (!string.IsNullOrWhiteSpace(dtoChild.TerminationReason))
                {
                    schemaChild.TerminationContractAttrs.ReasonForTermination =
                        (CorporateSchemaContract.ReasonForTerminationType)
                            Enum.Parse(
                                typeof(CorporateSchemaContract.ReasonForTerminationType),
                                dtoChild.TerminationReason);
                }

                dtoChild.contractAllocations.ForEach(dtoAlloc =>
                {
                    var schemaAlloc =
                        schemaChild.contractAllocations.Single(a =>
                            a.contractAllocationNumber == dtoAlloc.contractAllocationNumber);

                    schemaAlloc.allocationTerminationAttrs.stopNewStartsFromDate =
                        dtoAlloc.StopNewStartsDate;

                    schemaAlloc.allocationTerminationAttrs.newStartsSuspendedReason =
                        dtoAlloc.NewStartsSuspendedReason;

                    schemaAlloc.allocationTerminationAttrs.fundingCessationDate =
                        dtoAlloc.FundingCessationDate;
                });
            });
        }

        private static string GetNullableString(string s)
            => string.IsNullOrWhiteSpace(s) ? "XX" : s;

        private static string Get11DigitString(string s)
            => string.IsNullOrWhiteSpace(s) ? "xxxxxxxxxxx" : s;
    }
}
