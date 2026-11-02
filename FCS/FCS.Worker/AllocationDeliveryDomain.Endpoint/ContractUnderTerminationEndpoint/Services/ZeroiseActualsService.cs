namespace AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint.Extensions;
    using Repositories;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractTermination;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class ZeroiseActualsService : IZeroiseActualsService
    {
        private readonly IFundingStreamPeriodRepository _fundingStreamPeriodRepository;

        private readonly IAllocationDeliverablePeriodActualAuditRepository
            _allocationDeliverablePeriodActualAuditRepository;

        private readonly IDate _date;

        public ZeroiseActualsService(IFundingStreamPeriodRepository fundingStreamPeriodRepository,
            IAllocationDeliverablePeriodActualAuditRepository allocationDeliverablePeriodActualAuditRepository,
            IDate date)
        {
            _fundingStreamPeriodRepository = fundingStreamPeriodRepository;
            _allocationDeliverablePeriodActualAuditRepository = allocationDeliverablePeriodActualAuditRepository;
            _date = date;
        }

        public async Task ConditionallyZeroiseActuals(ConnectionInfo connectionInfo,
            TerminationAllocation terminationAllocation,
            Func<ContractAllocationActualsType, Task> publishAllocationActuals)
        {
            FundingStreamPeriod fundingStreamPeriod =
                await _fundingStreamPeriodRepository.GetFundingStreamPeriod(connectionInfo,
                    terminationAllocation.FundingStreamPeriodCode);

            if (fundingStreamPeriod.IsFspActive(_date.GetCalculationDate().Date))
            {
                IReadOnlyCollection<AllocationDeliverablePeriodActualAudit> latestCollection =
                    await _allocationDeliverablePeriodActualAuditRepository.GetLatestCollectionReturn(
                        connectionInfo,
                        terminationAllocation.AllocationNumber);

                bool RequiresZeroisation(AllocationDeliverablePeriodActualAudit deliverablePeriod)
                    => IsPeriodLaterThanDate(deliverablePeriod.Period, terminationAllocation.TerminationDate) &&
                       deliverablePeriod.HasActualValueOrVolume();

                if (latestCollection.Any(actual => actual.HasActualValueOrVolume()))
                {
                    List<ActualsSummaryType> actualsSummaries = latestCollection.Select(deliverablePeriod =>
                    {
                        if (RequiresZeroisation(deliverablePeriod))
                        {
                            return deliverablePeriod.ToZeroisedActualsSummaryType();
                        }

                        return deliverablePeriod.ToActualsSummaryType();
                    }).ToList();

                    if (actualsSummaries.Any())
                    {
                        var firstActualAudit = latestCollection.First();

                        ContractAllocationActualsType actualsType =
                            AllocationActualsMapper.Map(firstActualAudit, actualsSummaries);

                        await publishAllocationActuals(actualsType);
                    }
                }
            }
        }

        private bool IsPeriodLaterThanDate(string period, DateTime? date)
        {
            return date.HasValue
                   && int.Parse(period) > int.Parse($"{date.Value:yyyyMM}");
        }
    }
}