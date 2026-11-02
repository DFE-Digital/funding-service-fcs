namespace FundingAllocation.Endpoints.ReleaseGroup
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using DataStore.Model;
    using Dto;
    using Extensions;
    using FundingAllocation.Services;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public class FundingAllocationsToContractTransformer : IFundingAllocationsToContractTransformer
    {
        private readonly ICfsToFcsCodeMappingService _cfsToFcsCodeMappingService;
        private readonly IFundingStreamPeriodRepository _fundingStreamPeriodRepository;

        public FundingAllocationsToContractTransformer(
            ICfsToFcsCodeMappingService cfsToFcsCodeMappingService,
            IFundingStreamPeriodRepository fundingStreamPeriodRepository)
        {
            _cfsToFcsCodeMappingService = cfsToFcsCodeMappingService;
            _fundingStreamPeriodRepository = fundingStreamPeriodRepository;
        }

        public async Task<ExtendedContractType> CreateContractFrom(
            IReadOnlyCollection<FundingAllocation> fundingAllocations,
            string contractNumber,
            string masterContractNumber,
            ContractItemsMappingResult contractItemsMappings,
            int contractVersionNumber,
            Func<(string fundingStream, int deliveryUkprn), int> getAllocationNumberForFundingStream)
        {
            var contractProviderUkprn = int.Parse(fundingAllocations.First().UKPRN);

            var contractAllocations = await CreateAllocationsFrom(
                contractProviderUkprn,
                fundingAllocations,
                contractItemsMappings,
                getAllocationNumberForFundingStream);

            var (startDate, endDate) = contractAllocations.GetEarliestStartDateAndLatestEndDate();

            return new ExtendedContractType
            {
                contracts = new List<ExtendedContractType>
                {
                    new ExtendedContractType
                    {
                        contractNumber = contractNumber,
                        contractVersionNumber = contractVersionNumber,
                        contractSubVersionNumber = 0,
                        period = new period
                        {
                            period1 = contractItemsMappings.FundingPeriodCode[2..],
                            periodType = new periodTypeType
                            {
                                periodTypeCode = contractItemsMappings.GetPeriodTypeCode()
                            }
                        },
                        contractor = new contractor
                        {
                            ukprn = contractProviderUkprn
                        },
                        fundingType = new fundingType
                        {
                            fundingTypeCode = contractItemsMappings.FundingTypeCode
                        },
                        hierarchyType = hierarchyType.CONTRACT,
                        contractValue = fundingAllocations.Sum(fa => fa.GetTotalPlannedValue()),
                        contractType1 = contractItemsMappings.ContractType,
                        SkipCaseloadAssignment = false,
                        SkipDocumentMerge = false,
                        SkipReviewAndInternalApproval = false,
                        DocumentationRequired = true,
                        IsNewRevisedNewOrUpdateDraft = true,
                        contractAllocations = contractAllocations.ToList(),
                        startDate = startDate,
                        endDate = endDate
                    }
                },
                contractNumber = masterContractNumber,
                contractVersionNumber = 1,
                contractor = new contractor
                {
                    ukprn = contractProviderUkprn
                },
                fundingType = new fundingType
                {
                    fundingTypeCode = contractItemsMappings.FundingTypeCode
                },
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contractType1 = contractItemsMappings.ContractType,
                startDate = startDate,
                endDate = endDate
            };
        }

        public async Task<IReadOnlyCollection<ExtendedContractAllocation>> CreateAllocationsFrom(
            int contractingUkprn,
            IReadOnlyCollection<FundingAllocation> fundingAllocations,
            ContractItemsMappingResult contractItemsMappings,
            Func<(string fundingStream, int deliveryUkprn), int> getAllocationNumberForFundingStream)
        {
            var cfsCodeToFcsCodeDictionary = await GetFspCodeDeliverableCodes(fundingAllocations);
            FspCodeDeliverable GetFspAndDeliverableCode(ProviderFundingInfo pfi) => cfsCodeToFcsCodeDictionary[pfi];

            var allocations = fundingAllocations.GetContractAllocationInfos(GetFspAndDeliverableCode)
                .Select(a =>
                {
                    var (startDate, endDate) = _fundingStreamPeriodRepository.GetFspStartAndEndDate(a.FundingStreamPeriodCode).Result;

                    return new ExtendedContractAllocation
                    {
                        DeliveryOrganisation = a.GetDeliveryUkprnIfDifferentToContracting(contractingUkprn),
                        fundingStreamPeriodCode = a.FundingStreamPeriodCode,
                        fundingStream = new fundingStream
                        {
                            fundingStreamCode = a.FundingStreamCode
                        },
                        maximumContractValue = a.GetTotalPlannedValue(),
                        contractAllocationNumber =
                            $"{a.AllocationReferencePrefix}-{getAllocationNumberForFundingStream((a.FundingStreamCode, a.DeliveryUkprn))}",
                        period = new period
                        {
                            period1 = contractItemsMappings.FundingPeriodCode[2..],
                            periodType = new periodTypeType
                            {
                                periodTypeCode = contractItemsMappings.GetPeriodTypeCode()
                            },
                            fundingStreamPeriods = new List<fundingStreamPeriodsFundingStreamPeriod>
                            {
                                new fundingStreamPeriodsFundingStreamPeriod
                                {
                                    fundingStreamPeriodCode = a.FundingStreamPeriodCode
                                }
                            }
                        },
                        startDate = startDate,
                        endDate = endDate,
                        contractDeliverables = a.Deliverables.Select(d =>
                        {
                            return new contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = d.DeliverableCode,
                                    deliverableName = d.DeliverableName
                                },
                                DisplayOrder = d.DisplayOrder,
                                plannedValue = d.GetTotalPlannedValue(),
                                contractDeliverablePeriods = Enumerable.Range(0, 12)
                                    .Select(m =>
                                    {
                                        var period = startDate.AddMonths(m);
                                        var periodWithYear = period.ToPeriod();
                                        var periodFromTable =
                                            d.Periods
                                                .SingleOrDefault(p => p.Period == periodWithYear);

                                        return new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                        {
                                            plannedValue = periodFromTable?.PlannedValue ?? 0,
                                            period = period.Month,
                                            year = periodWithYear / 100,
                                            periodName = period.ToPeriodString(),
                                            displayOrder = periodWithYear
                                        };
                                    }).ToList()
                            };
                        }).ToList()
                    };
                }).ToList();

            return allocations;
        }

        private async Task<IDictionary<ProviderFundingInfo, FspCodeDeliverable>> GetFspCodeDeliverableCodes(
            IReadOnlyCollection<FundingAllocation> fundingAllocations)
        {
            var providerFundingInfoInputs =
                fundingAllocations.SelectMany(fa => fa.GetProviderAllocationLines()
                    .Select(a => new ProviderFundingInfo(a.providerFundingAllocation.ProviderFunding.ProviderType,
                        a.providerFundingAllocation.ProviderFunding.ProviderSubType, fa.AllocationFundingStream,
                        fa.Period, a.fundingAllocationLine.FundingLineCode, fa.UKPRN))).ToList();

            Dictionary<ProviderFundingInfo, FspCodeDeliverable> cfsCodeToFscCodeDictionary = new Dictionary<ProviderFundingInfo, FspCodeDeliverable>();

            foreach (var providerFundingInfo in providerFundingInfoInputs)
            {
                await cfsCodeToFscCodeDictionary.AddIfNotPresent(providerFundingInfo, _cfsToFcsCodeMappingService.GetFspCodeDeliverable);
            }

            return cfsCodeToFscCodeDictionary;
        }
    }
}
