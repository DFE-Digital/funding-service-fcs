namespace PaymentManagement.Calculation.Services
{
    using System;
    using System.Linq;
    using Extensions;
    using Optional.Collections;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;

    public class FundingClaimReconciliationService : IFundingClaimReconciliationService
    {
        private readonly IAllocationQueryRepository _allocationQueryRepository;
        private readonly IDeliverablePaymentRepository _deliverablePaymentRepository;

        public FundingClaimReconciliationService(IAllocationQueryRepository allocationQueryRepository, IDeliverablePaymentRepository deliverablePaymentRepository)
        {
            _allocationQueryRepository = allocationQueryRepository;
            _deliverablePaymentRepository = deliverablePaymentRepository;
        }

        public bool IsPayableFcrPublishedForAllocation(string allocationNumber, ConnectionInfo connectionInfo)
        {
            return _allocationQueryRepository.IsPayableFcrPublishedForAllocation(allocationNumber, connectionInfo);
        }

        public Allocation CreatePaymentScheduleFromPreviousVersion(allocationType allocation, ConnectionInfo connectionInfo)
        {
            return _allocationQueryRepository.GetPreviousVersion(allocation.contractAllocationNumber, allocation.contractReference.contractVersionNumber, connectionInfo)
                .Match(some: previousVersion =>
                {
                    var previousVersionDeliverablePeriodPaymentInfos = _deliverablePaymentRepository.GetDeliverablePeriodPaymentInfos(allocationNumber: allocation.contractAllocationNumber,
                        versionNumber: previousVersion, connectionInfo);

                    allocation.FlattenDeliverables(allocation.contractDeliverables).ForEach(d =>
                        {
                            var prevVersionPeriodsForDeliverable = previousVersionDeliverablePeriodPaymentInfos
                                .Where(dppi => dppi.DeliverableCode == d.deliverable.deliverableCode).ToList();
                            d.contractDeliverablePeriods.ForEach(dp =>
                            {
                                prevVersionPeriodsForDeliverable.SingleOrNone(pvDp => pvDp.Period.ToString() == dp.period.periodValue).MatchSome(
                                    prevDp => { prevDp.PlannedValue = dp.plannedValue; });
                            });
                        });
                    return previousVersionDeliverablePeriodPaymentInfos.ToPaymentSchedule(allocation);
                },
                none: () => throw new ArgumentException($"We do not have a previous version of the allocation for allocation: {allocation.contractAllocationNumber}, version: {allocation.contractAllocationNumber}"));
        }
    }
}
