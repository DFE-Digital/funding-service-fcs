namespace ContractCreateDomain.IncrementContractVersionEndpoint.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using Repositories;
    using SFA.FCT.ContractCreateDomain.Implementation.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class LevyContractAllocationService : ILevyContractAllocationService
    {
        private const string PayableNonLevyFundingStreamCode = "NONLEVY";
        private const string PayableNonLevyFundingStreamPeriodCode = "NONLEVY2019";
        private const string PayableNonLevyPeriod = "1799";
        private const periodTypeCodeType PayableNonLevyPeriodTypeCode = periodTypeCodeType.LEVY;

        private readonly IFundingStreamPeriodRepository _fundingStreamPeriodRepository;
        private readonly IAllocationNumberRepository _allocationNumberRepository;
        private readonly ISequenceRepository _sequenceRepository;

        public LevyContractAllocationService(
            IFundingStreamPeriodRepository fundingStreamPeriodRepository,
            IAllocationNumberRepository allocationNumberRepository,
            ISequenceRepository sequenceRepository)
        {
            _fundingStreamPeriodRepository = fundingStreamPeriodRepository;
            _allocationNumberRepository = allocationNumberRepository;
            _sequenceRepository = sequenceRepository;
        }

        public async Task AddPayableNonLevyContractAllocationIfNotPresent(ExtendedContractType childContract, ConnectionInfo connectionInfo)
        {
            if (!HasPayableNonLevyContractAllocation(childContract))
            {
                FundingStreamPeriod fsp = await _fundingStreamPeriodRepository.Find(PayableNonLevyFundingStreamPeriodCode, connectionInfo)
                    .ConfigureAwait(continueOnCapturedContext: false);  
                string allocationNumberPrefix = _allocationNumberRepository.GetAllocationNumberPrefix(PayableNonLevyFundingStreamPeriodCode);

                int numberSuffix = await _sequenceRepository.GetNextNumber(SequenceType.Allocation,
                    PayableNonLevyFundingStreamCode, connectionInfo);

                childContract.contractAllocations.Add(new ExtendedContractAllocation
                {
                    contractAllocationNumber = $"{allocationNumberPrefix}-{numberSuffix}",
                    fundingStream = new fundingStream
                    {
                        fundingStreamCode = PayableNonLevyFundingStreamCode
                    },
                    fundingStreamPeriodCode = fsp.FundingStreamPeriodCode,
                    startDate = fsp.StartDate,
                    period = new Period
                    {
                        period1 = PayableNonLevyPeriod,
                        periodType = new periodTypeType
                        {
                            periodTypeCode = PayableNonLevyPeriodTypeCode
                        }
                    },
                    contractDeliverables = fsp.LegalDeliverables
                        .Select(ld => new contractDeliverablesTypeContractDeliverable
                        {
                            deliverable = new deliverableType
                            {
                                deliverableCode = ld.DeliverableCode,
                                deliverableName = ld.DeliverableName
                            },
                            DisplayOrder = ld.DisplayOrder,
                            contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                            {
                                new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                {
                                    periodName = $"{fsp.StartDate:MMM}-{fsp.StartDate:yy}",
                                    year = fsp.StartDate.Year,
                                    period = fsp.StartDate.Month,
                                    periodType = new periodTypeType
                                    {
                                        periodTypeCode = periodTypeCodeType.CM
                                    },
                                    displayOrder = int.Parse($"{fsp.StartDate.Year}{fsp.StartDate:MM}")
                                }
                            }
                        })
                        .ToList()
                });
            }
        }

        private static bool HasPayableNonLevyContractAllocation(ExtendedContractType childContract)
        {
            return childContract.contractAllocations.Exists(a => a.fundingStreamPeriodCode == PayableNonLevyFundingStreamPeriodCode);
        }
    }
}