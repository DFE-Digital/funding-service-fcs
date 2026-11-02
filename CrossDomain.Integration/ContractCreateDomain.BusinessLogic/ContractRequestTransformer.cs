namespace SFA.FCT.ContractCreateDomain.BusinessLogic
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using AutoMapper;
    using contractor = CrossDomain.Integration.Entities.ContractRequest.contractor;
    using ContractRequest = CrossDomain.Integration.Entities.ContractRequest;
    using CorpContract = CrossDomain.Integration.Entities.CorporateContract;
    using deliverableType = CrossDomain.Integration.Entities.ContractRequest.deliverableType;
    using periodTypeType = CrossDomain.Integration.Entities.CorporateContract.periodTypeType;

    public class ContractRequestTransformer : IContractRequestTransformer
    {
        /// <summary>
        /// Transforms a Contract Request to both a Corp Contract (used for Doc Gen) and an ExtendedContractType used elsewhere
        /// </summary>
        /// <param name="contractRequestType"></param>
        /// <returns>Both a corporate contract and an extended Contract Type</returns>
        public CorpContract.ExtendedContractType TransformToCorpContractType(ContractRequest.contractRequestType contractRequestType)
        {
            SetupMapper();

            // the mapper will map all the fields except the period ones, they are not 121 and require a transform in code
            var extendedContractType = Mapper.Map<ContractRequest.contractType, CorpContract.ExtendedContractType>(contractRequestType.contract);

            // we need to transform the periods
            extendedContractType.period = CreateCorpContractPeriod(contractRequestType.contract.period, string.Empty);
            extendedContractType.fundingStream = CreateFundingStream(contractRequestType.contract);
            extendedContractType.fundingType = CreateFundingType(contractRequestType.contract);
            int index = 0;

            foreach (var contractReqContract in contractRequestType.contract.contracts)
            {
                var corpContract = extendedContractType.contracts[index];
                corpContract.period = CreateCorpContractPeriod(contractReqContract.period, string.Empty);
                corpContract.fundingStream = CreateFundingStream(contractReqContract);
                corpContract.fundingType = CreateFundingType(contractRequestType.contract);
                corpContract.contractStatus = new CorpContract.contractStatusType
                {
                    parentStatus = contractReqContract.status,
                    status = contractReqContract.subStatus
                };
                int indexAllocations = 0;
                foreach (var contractAllocation in extendedContractType.contracts[index].contractAllocations)
                {
                    var contractReqAllocation = contractReqContract.contractAllocations[indexAllocations];
                    contractAllocation.fundingStream.fundingStreamCode =
                        contractReqAllocation.fundingStreamCode;

                    contractAllocation.period =
                        CreateCorpContractPeriod(
                            contractReqAllocation.period,
                            contractReqAllocation.fundingStreamPeriodCode);

                    int indexContractDeliverable = 0;

                    foreach (var deliverable in contractAllocation.contractDeliverables)
                    {
                        int indexContractDeliverablePeriod = 0;

                        foreach (var deliverablePeriod in deliverable.contractDeliverablePeriods)
                        {
                            var contractReqPeriodTypeType = contractReqContract.contractAllocations[indexAllocations].contractDeliverables[indexContractDeliverable].contractDeliverablePeriods[indexContractDeliverablePeriod].periodType;

                            deliverablePeriod.periodType = CreateCorpPeriodType(contractReqPeriodTypeType);
                            indexContractDeliverablePeriod++;
                        }

                        indexContractDeliverable++;
                    }

                    indexAllocations++;
                }

                index++;
            }

            return extendedContractType;
        }

        public CorpContract.contract TransformToCorpContract(CorpContract.ExtendedContractType extendedContractType)
        {
            Mapper.CreateMap<CorpContract.ExtendedContract, CorpContract.contract>();
            Mapper.CreateMap<CorpContract.ExtendedContractType, CorpContract.contractType>();
            Mapper.CreateMap<CorpContract.ExtendedContractAllocation, CorpContract.contractAllocationsContractAllocation>();
            var contractType = Mapper.Map<CorpContract.ExtendedContractType, CorpContract.contractType>(extendedContractType);

            // we now need to create corp contract derived class
            Mapper.CreateMap<CorpContract.contractType, CorpContract.contract>();
            return Mapper.Map<CorpContract.contractType, CorpContract.contract>(contractType);
        }

        public ContractRequest.contractType TransformAllocationsToContractRequestContract(
            IEnumerable<ContractRequest.AllocationValueData> allocationValueDataItems, string contractNumber, int ukprn)
        {
            ContractRequest.contractType masterContract = new ContractRequest.contractType();
            masterContract.contracts = new List<ContractRequest.contractType>();
            ContractRequest.contractType subContract = new ContractRequest.contractType();
           
            subContract.contractNumber = contractNumber;
            subContract.contractor = new contractor
            {
                ukprn = ukprn
            };
            
            foreach (var allocationValueDataItem in allocationValueDataItems)
            {
                subContract.contractAllocations.Add(new ContractRequest.contractAllocation
                {
                    maximumContractValue = allocationValueDataItem.MaximumContractValue,
                    contractAllocationNumber = allocationValueDataItem.ContractAllocationNumber
                });
            }
            
            masterContract.contracts.Add(subContract);

            return masterContract;
        }

        private CorpContract.fundingStream CreateFundingStream(
            ContractRequest.contractType contractType)
        {
            if (contractType != null)
            {
                return new CorpContract.fundingStream
                {
                    fundingStreamCode = contractType.fundingTypeCode
                };
            }
            else
            {
                return null;
            }
        }

        private CorpContract.fundingType CreateFundingType(ContractRequest.contractType contractType)
        {
            if (contractType != null)
            {
                return new CorpContract.fundingType
                {
                    fundingTypeCode = contractType.fundingTypeCode
                };
            }
            else
            {
                return null;
            }
        }

        private CorpContract.period CreateCorpContractPeriod(
            ContractRequest.periodType period, string fundingStreamPeriodCode)
        {
            if (period != null)
            {
                return new CorpContract.period
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

            return null;
        }

        private periodTypeType CreateCorpPeriodType(
            CrossDomain.Integration.Entities.ContractRequest.periodTypeType contractReqPeriodTypeType)
        {
            var corpPeriodTypeType = new periodTypeType();
            const string space = " ";
            const string hyphen = "-";

            if (!string.IsNullOrEmpty(contractReqPeriodTypeType.periodTypeCode))
            {
                corpPeriodTypeType.periodTypeCode =
                    (CorpContract.periodTypeCodeType)
                        Enum.Parse(typeof(CorpContract.periodTypeCodeType), contractReqPeriodTypeType.periodTypeCode);
            }

            if (!string.IsNullOrEmpty(contractReqPeriodTypeType.periodTypeName))
            {
                corpPeriodTypeType.periodTypeName = (CorpContract.periodTypeNameType)
                    Enum.Parse(
                        typeof(CorpContract.periodTypeNameType),
                        contractReqPeriodTypeType.periodTypeName.Replace(space, string.Empty).Replace(hyphen, string.Empty).ToUpper());
            }

            return corpPeriodTypeType;
        }

        private void SetupMapper()
        {
            Mapper.CreateMap<ContractRequest.contractType, CorpContract.ExtendedContractType>().ForMember(ct => ct.period, opt => opt.Ignore());
            Mapper.CreateMap<ContractRequest.contractType, CrossDomain.Integration.Entities.CorporateContract.contractType>().ForMember(ct => ct.period, opt => opt.Ignore());
            Mapper.CreateMap<ContractRequest.contractAllocation, CorpContract.ExtendedContractAllocation>().ForMember(ct => ct.period, opt => opt.Ignore()).ForMember(dest => dest.reasonForAmendment, opt => opt.MapFrom(origin => origin.amendmentReason));
            Mapper.CreateMap<ContractRequest.contractAllocation, CorpContract.ExtendedContractAllocation>()
                .ForMember(ct => ct.period, opt => opt.Ignore())
                .ForMember(dest => dest.reasonForAmendment, opt => opt.MapFrom(origin => origin.amendmentReason))
                .ForMember(dest => dest.FundingCessationDate, opts => opts.MapFrom(src => src.TerminationDate));
            Mapper.CreateMap<ContractRequest.contractAllocation, CrossDomain.Integration.Entities.CorporateContract.contractAllocationsContractAllocation>().ForMember(ct => ct.period, opt => opt.Ignore()).ForMember(dest => dest.reasonForAmendment, opt => opt.MapFrom(origin => origin.amendmentReason));
            Mapper.CreateMap<contractor, CrossDomain.Integration.Entities.CorporateContract.contractor>()
                .ForMember(dest => dest.Status, opts => opts.MapFrom(src => src.organisationStatus));
            Mapper.CreateMap<deliverableType, CrossDomain.Integration.Entities.CorporateContract.deliverableType>();
            Mapper.CreateMap<ContractRequest.contractDeliverablePeriodType, CorpContract.contractDeliverablePeriodsTypeContractDeliverablePeriod>().ForMember(cdpt => cdpt.periodType, opt => opt.Ignore());
            Mapper.CreateMap<ContractRequest.contractDeliverable, CorpContract.contractDeliverablesTypeContractDeliverable>();
            Mapper.CreateMap<CrossDomain.Integration.Entities.CorporateContract.contractType, CorpContract.contract>();
        }
    }
}