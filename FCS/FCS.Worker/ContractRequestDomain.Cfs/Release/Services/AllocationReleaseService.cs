namespace ContractRequestDomain.Cfs.Release.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Common.Dtos;
    using Dto;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class AllocationReleaseService : IAllocationReleaseService
    {
        private readonly IAllocationRepository _allocationRepository;
        private readonly IContractNumberEnricher _contractNumberEnricher;

        public AllocationReleaseService(IAllocationRepository allocationRepository, IContractNumberEnricher contractNumberEnricher)
        {
            _allocationRepository = allocationRepository;
            _contractNumberEnricher = contractNumberEnricher;
        }

        public Task ReleaseAllocations(string fundingType, string fundingPeriod, Func<ContractCfsAllocation, Task> contractGenerated, ConnectionInfo connectionInfo)
        {
            IReadOnlyCollection<Allocation> allocationsForRelease =
                _allocationRepository.GetAllocationsForRelease(fundingType: fundingType, fundingPeriod: fundingPeriod);

            IEnumerable<Task> contractGeneratedTasks = allocationsForRelease
                .Select(a =>
                {
                    var contract = TransformToContract(a);
                    _contractNumberEnricher.EnrichWithContractAndAllocationNumbers(contract, connectionInfo);
                    return new ContractCfsAllocation
                    {
                        Contract = contract,
                        CfsAllocationId = a.CrmEntityId.Value
                    };
                })
                .Select(contractGenerated);

            return Task.WhenAll(contractGeneratedTasks);
        }

        private static ExtendedContractType TransformToContract(Allocation allocation)
        {
            const string contractType = "Contract for Services";
            const string fundingStreamCode = "ALLF";
            const string period = "1819";
            const periodTypeCodeType periodTypeCode = periodTypeCodeType.AY;
            const periodTypeNameType periodTypeName = periodTypeNameType.ACADEMICYEAR;
            const int deliverableDisplayOrder = 1;
            const string deliverableName = "Advanced Learner Loans Facility";

            return new ExtendedContractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contractVersionNumber = 1,
                contractSubVersionNumber = 0,
                startDate = allocation.StartDate,
                endDate = allocation.EndDate,
                amendmentType = "None",
                contractor = new contractor
                {
                    ukprn = allocation.Ukprn
                },
                fundingType = new fundingType
                {
                    fundingTypeCode = allocation.FundingTypeCode
                },
                fundingStream = new fundingStream
                {
                    fundingStreamCode = fundingStreamCode
                },
                contracts = new List<ExtendedContractType>
                {
                    new ExtendedContractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractVersionNumber = 1,
                        contractSubVersionNumber = 0,
                        startDate = allocation.StartDate,
                        endDate = allocation.EndDate,
                        DocumentationRequired = true,
                        contractType1 = contractType,
                        contractValue = allocation.GetProfileValue(),
                        amendmentType = "New",
                        contractor = new contractor
                        {
                            ukprn = allocation.Ukprn
                        },
                        fundingType = new fundingType
                        {
                            fundingTypeCode = allocation.FundingTypeCode
                        },
                        fundingStream = new fundingStream
                        {
                            fundingStreamCode = fundingStreamCode
                        },
                        period = new period
                        {
                            period1 = period,
                            periodType = new periodTypeType
                            {
                                periodTypeCode = periodTypeCode,
                                periodTypeName = periodTypeName
                            }
                        },
                        contractAllocations = new List<ExtendedContractAllocation>
                        {
                            new ExtendedContractAllocation
                            {
                                fundingStreamPeriodCode = allocation.FundingStreamPeriodCode,
                                fundingStream = new fundingStream
                                {
                                    fundingStreamCode = fundingStreamCode
                                },
                                startDate = allocation.StartDate,
                                endDate = allocation.EndDate,
                                maximumContractValue = allocation.GetProfileValue(),
                                period = new period
                                {
                                    period1 = period,
                                    periodType = new periodTypeType
                                    {
                                        periodTypeCode = periodTypeCode,
                                        periodTypeName = periodTypeName
                                    }
                                },
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        ParentDeliverableCode = null,
                                        plannedValue = allocation.GetProfileValue(),
                                        DisplayOrder = deliverableDisplayOrder,
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = allocation.DeliverableCode,
                                            deliverableName = deliverableName,
                                            fundingStreamCode = fundingStreamCode
                                        },
                                        contractDeliverablePeriods = allocation.AllocationPeriods
                                            .Select(ap => new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = ap.Month,
                                                year = ap.Year,
                                                periodName = ap.Period,
                                                plannedValue = ap.ProfileValue,
                                                displayOrder = int.Parse($"{ap.Year}{ap.Month:D2}"),
                                                aggregate = false,
                                                periodType = new periodTypeType
                                                {
                                                    periodTypeCode = periodTypeCodeType.CM,
                                                    periodTypeName = periodTypeNameType.CALENDARMONTH
                                                }
                                            })
                                            .ToList()
                                    }
                                }
                            }
                        }
                    }
                }
            };
        }
    }
}