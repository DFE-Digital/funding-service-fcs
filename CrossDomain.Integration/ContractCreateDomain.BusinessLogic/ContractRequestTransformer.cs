
namespace SFA.FCT.ContractCreateDomain.BusinessLogic
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using AutoMapper;
    using Microsoft.Extensions.Logging.Abstractions;          // <-- for NullLoggerFactory (AM v15)
    using Contractor = CrossDomain.Integration.Entities.ContractRequest.Contractor;
    using ContractRequest = CrossDomain.Integration.Entities.ContractRequest;
    using CorpContract = CrossDomain.Integration.Entities.CorporateContract;
    using deliverableType = CrossDomain.Integration.Entities.ContractRequest.deliverableType;
    using periodTypeType = CrossDomain.Integration.Entities.CorporateContract.periodTypeType;

    public class ContractRequestTransformer : IContractRequestTransformer
    {
        private static IMapper _mapper;
        private static readonly object _mapperLock = new();

        private static IMapper GetMapper()
        {
            if (_mapper != null) return _mapper;

            lock (_mapperLock)
            {
                if (_mapper != null) return _mapper;

                // AutoMapper v15: constructor requires ILoggerFactory
                // If you prefer DI, inject ILoggerFactory and pass it instead of NullLoggerFactory.Instance.
                var config = new AutoMapper.MapperConfiguration(cfg =>
                {
                    // Request -> Corporate Extended
                    cfg.CreateMap<ContractRequest.contractType, CorpContract.ExtendedContractType>()
                       .ForMember(ct => ct.period, opt => opt.Ignore());

                    // Request -> Corporate contractType (intermediate)
                    cfg.CreateMap<ContractRequest.contractType, CorpContract.contractType>()
                       .ForMember(ct => ct.period, opt => opt.Ignore());

                    // Allocations
                    cfg.CreateMap<ContractRequest.contractAllocation, CorpContract.ExtendedContractAllocation>()
                       .ForMember(ct => ct.period, opt => opt.Ignore())
                       .ForMember(dest => dest.reasonForAmendment, opt => opt.MapFrom(src => src.amendmentReason))
                       .ForMember(dest => dest.FundingCessationDate, opt => opt.MapFrom(src => src.TerminationDate));

                    // Contractor (Request -> Corporate)
                    // If your CorporateContract model has lowercase 'contractor', replace 'Contractor' with 'contractor'.
                    cfg.CreateMap<Contractor, CorpContract.Contractor>()
                       .ForMember(dest => dest.Status, opts => opts.MapFrom(src => src.organisationStatus));

                    // Deliverables
                    cfg.CreateMap<deliverableType, CorpContract.deliverableType>();

                    // Deliverable periods: periodType is set manually
                    cfg.CreateMap<ContractRequest.contractDeliverablePeriodType, CorpContract.contractDeliverablePeriodsTypeContractDeliverablePeriod>()
                       .ForMember(d => d.periodType, opt => opt.Ignore());

                    cfg.CreateMap<ContractRequest.contractDeliverable, CorpContract.contractDeliverablesTypeContractDeliverable>();

                    // Extended -> contractType -> Contract
                    cfg.CreateMap<CorpContract.ExtendedContractType, CorpContract.contractType>();
                    cfg.CreateMap<CorpContract.contractType, CorpContract.Contract>();
                }, NullLoggerFactory.Instance); // <-- v15 requirement  [1](https://docs.automapper.io/en/stable/Configuration.html)[2](https://docs.automapper.io/en/latest/Setup.html)

                // Optional: validate mappings at startup
                config.AssertConfigurationIsValid();

                _mapper = config.CreateMapper();
                return _mapper;
            }
        }

        /// <summary>
        /// Transform a Contract Request to Corporate ExtendedContractType (DocGen etc.)
        /// </summary>
        public CorpContract.ExtendedContractType TransformToCorpContractType(ContractRequest.contractRequestType contractRequestType)
        {
            var mapper = GetMapper();

            // Base map (period/funding set manually)
            var extendedContractType = mapper.Map<ContractRequest.contractType, CorpContract.ExtendedContractType>(
                contractRequestType.contract);

            // Period & funding (not 1:1)
            extendedContractType.period = CreateCorpContractPeriod(contractRequestType.contract.period, string.Empty);
            extendedContractType.fundingStream = CreateFundingStream(contractRequestType.contract);
            extendedContractType.fundingType = CreateFundingType(contractRequestType.contract);

            // Ensure lists are non-null with the CORRECT element types
            if (extendedContractType.contracts == null)
                extendedContractType.contracts = new List<CorpContract.ExtendedContractType>();

            if (contractRequestType.contract.contracts == null)
                contractRequestType.contract.contracts = new List<ContractRequest.contractType>();

            // Keep the two lists in sync by ensuring the destination has at least the same count
            while (extendedContractType.contracts.Count < contractRequestType.contract.contracts.Count)
                extendedContractType.contracts.Add(new CorpContract.ExtendedContractType());

            for (int i = 0; i < contractRequestType.contract.contracts.Count; i++)
            {
                var srcSub = contractRequestType.contract.contracts[i];
                var dstSub = extendedContractType.contracts[i];

                // Period & funding for each sub-contract
                dstSub.period = CreateCorpContractPeriod(srcSub.period, string.Empty);
                dstSub.fundingStream = CreateFundingStream(srcSub);
                dstSub.fundingType = CreateFundingType(contractRequestType.contract);

                // Status
                dstSub.contractStatus = new CorpContract.contractStatusType
                {
                    parentStatus = srcSub.status,
                    status = srcSub.subStatus
                };

                // Allocations
                if (dstSub.contractAllocations == null)
                    dstSub.contractAllocations = new List<CorpContract.ExtendedContractAllocation>();

                if (srcSub.contractAllocations == null)
                    srcSub.contractAllocations = new List<ContractRequest.contractAllocation>();

                // Ensure allocation counts match (we update existing destination allocations)
                while (dstSub.contractAllocations.Count < srcSub.contractAllocations.Count)
                    dstSub.contractAllocations.Add(new CorpContract.ExtendedContractAllocation());

                for (int j = 0; j < srcSub.contractAllocations.Count; j++)
                {
                    var srcAlloc = srcSub.contractAllocations[j];
                    var dstAlloc = dstSub.contractAllocations[j];

                    dstAlloc.fundingStream ??= new CorpContract.fundingStream();
                    dstAlloc.fundingStream.fundingStreamCode = srcAlloc.fundingStreamCode;

                    dstAlloc.period = CreateCorpContractPeriod(
                        srcAlloc.period,
                        srcAlloc.fundingStreamPeriodCode);

                    // Deliverables: guard against nulls; if destination doesn’t have items yet,
                    // we skip aligning by index and only set periodType where both sides exist.
                    if (dstAlloc.contractDeliverables == null || srcAlloc.contractDeliverables == null)
                        continue;

                    while (dstAlloc.contractDeliverables.Count < srcAlloc.contractDeliverables.Count)
                        dstAlloc.contractDeliverables.Add(new CorpContract.contractDeliverablesTypeContractDeliverable());

                    for (int k = 0; k < srcAlloc.contractDeliverables.Count; k++)
                    {
                        var srcDel = srcAlloc.contractDeliverables[k];
                        var dstDel = dstAlloc.contractDeliverables[k];

                        if (dstDel.contractDeliverablePeriods == null || srcDel.contractDeliverablePeriods == null)
                            continue;

                        while (dstDel.contractDeliverablePeriods.Count < srcDel.contractDeliverablePeriods.Count)
                            dstDel.contractDeliverablePeriods.Add(new CorpContract.contractDeliverablePeriodsTypeContractDeliverablePeriod());

                        for (int m = 0; m < srcDel.contractDeliverablePeriods.Count; m++)
                        {
                            var srcPeriodType = srcDel.contractDeliverablePeriods[m].periodType;
                            dstDel.contractDeliverablePeriods[m].periodType = CreateCorpPeriodType(srcPeriodType);
                        }
                    }
                }
            }

            return extendedContractType;
        }

        public CorpContract.Contract TransformToCorpContract(CorpContract.ExtendedContractType extendedContractType)
        {
            var mapper = GetMapper();
            var contractType = mapper.Map<CorpContract.contractType>(extendedContractType);
            return mapper.Map<CorpContract.Contract>(contractType);
        }

        // Optional overload if callers have a contractType already
        public CorpContract.Contract TransformToCorpContract(CorpContract.contractType contractType)
        {
            var mapper = GetMapper();
            return mapper.Map<CorpContract.Contract>(contractType);
        }

        public ContractRequest.contractType TransformAllocationsToContractRequestContract(
            IEnumerable<ContractRequest.AllocationValueData> allocationValueDataItems,
            string contractNumber, int ukprn)
        {
            var masterContract = new ContractRequest.contractType
            {
                contracts = new List<ContractRequest.contractType>()
            };

            var subContract = new ContractRequest.contractType
            {
                contractNumber = contractNumber,
                contractor = new Contractor { ukprn = ukprn },
                contractAllocations = new List<ContractRequest.contractAllocation>()
            };

            foreach (var item in allocationValueDataItems ?? Enumerable.Empty<ContractRequest.AllocationValueData>())
            {
                subContract.contractAllocations.Add(new ContractRequest.contractAllocation
                {
                    maximumContractValue = item.MaximumContractValue,
                    contractAllocationNumber = item.ContractAllocationNumber
                });
            }

            masterContract.contracts.Add(subContract);
            return masterContract;
        }

        private CorpContract.fundingStream CreateFundingStream(ContractRequest.contractType contractType)
            => contractType == null ? null : new CorpContract.fundingStream
            {
                fundingStreamCode = contractType.fundingTypeCode
            };

        private CorpContract.fundingType CreateFundingType(ContractRequest.contractType contractType)
            => contractType == null ? null : new CorpContract.fundingType
            {
                fundingTypeCode = contractType.fundingTypeCode
            };

        private CorpContract.Period CreateCorpContractPeriod(
            ContractRequest.periodType period, string fundingStreamPeriodCode)
        {
            if (period == null) return null;

            return new CorpContract.Period
            {
                startDate = period.startDate,
                endDate = period.endDate,
                period1 = period.period,
                periodType = CreateCorpPeriodType(period.periodType1),
                fundingStreamPeriods = new[]
                {
                    new CorpContract.fundingStreamPeriodsFundingStreamPeriod
                    {
                        fundingStreamPeriodCode = fundingStreamPeriodCode
                    }
                }.ToList()
            };
        }

        private periodTypeType CreateCorpPeriodType(
            CrossDomain.Integration.Entities.ContractRequest.periodTypeType reqType)
        {
            var result = new periodTypeType();
            const string space = " ";
            const string hyphen = "-";

            if (!string.IsNullOrEmpty(reqType.periodTypeCode))
            {
                result.periodTypeCode = (CorpContract.periodTypeCodeType)
                    Enum.Parse(typeof(CorpContract.periodTypeCodeType), reqType.periodTypeCode);
            }

            if (!string.IsNullOrEmpty(reqType.periodTypeName))
            {
                result.periodTypeName = (CorpContract.periodTypeNameType)
                    Enum.Parse(typeof(CorpContract.periodTypeNameType),
                        reqType.periodTypeName.Replace(space, string.Empty)
                                             .Replace(hyphen, string.Empty)
                                             .ToUpper());
            }

            return result;
        }
    }
}
