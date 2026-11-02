namespace SFA.FCT.Operations.Integrity.IntegrityCheckers
{
    using System.Linq;
    using DTOs;
    using Repositories;
    using Utils;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using System.Collections.Generic;
    using Framework.Logging.Interfaces;
    using ClosedCollectionRepository = Repositories.ClosedCollectionRepository;

    /**
     * This checker is not called, if it was to be called it wouldn't do anything as CollectionTypesToValidate is empty
     */
    public class PeriodLevelSummarisedActualsToDeliverablePaymentActualChecker : SummarisedActualsToDeliverablePaymentActualChecker<PeriodLevelSummarisedActualsToDeliverablePaymentActualChecker.PeriodLevelDifferenceItem>
    {
        private readonly PaasDeliverablePaymentLazyRepository _paasDeliverablePaymentLazyRepository;

        public PeriodLevelSummarisedActualsToDeliverablePaymentActualChecker(
            IMonitoringDeliverablesDbContext monitoringDeliverablesDbContext,
            PaasDeliverablePaymentLazyRepository paasDeliverablePaymentLazyRepository,
            SummarisedActualRepository summarisedActualRepository,
            ClosedCollectionRepository closedCollectionRepository,
            ILogger logger,
            IMonitoringDeliverablesRepository monitoringDeliverablesRepository)
            : base(summarisedActualRepository, closedCollectionRepository, logger, monitoringDeliverablesRepository, null, null, null, null)
        {
            _paasDeliverablePaymentLazyRepository = paasDeliverablePaymentLazyRepository;
        }

        protected override IEnumerable<string> CollectionTypesToValidate => Enumerable.Empty<string>(); // currently no period-level collections to check

        protected override IReadOnlyCollection<PeriodLevelDifferenceItem> GetDifferencesItemsForAllocation(AllocationActualsPaas allocationActuals)
        {
            var differenceItems = new List<PeriodLevelDifferenceItem>();

            var periodActuals = SplitAllocationActualsByPeriod(allocationActuals);

            foreach (var period in periodActuals)
            {
                var paasActualValue = _paasDeliverablePaymentLazyRepository.SumActualValuesForPeriod(period.AllocationNumber, period.VersionNumber, period.Period);
                var paasActualVolume = _paasDeliverablePaymentLazyRepository.SumActualVolumesForPeriod(period.AllocationNumber, period.VersionNumber, period.Period);

                if (period.GetTotalActualValue() != paasActualValue || period.GetTotalActualVolume() != paasActualVolume)
                {
                    differenceItems.Add(new PeriodLevelDifferenceItem
                    {
                        Key = period.Key,
                        ContractNumber = period.ContractNumber,
                        AllocationNumber = period.AllocationNumber,
                        VersionNumber = period.VersionNumber,
                        Period = period.Period,
                        ReportedActualValue = period.GetTotalActualValue(),
                        ReportedActualVolume = period.GetTotalActualVolume(),
                        PaasActualValue = paasActualValue,
                        PaasActualVolume = paasActualVolume,
                        Message = "Differences in values between SummarisedActuals and PaaS"
                    });
                }
            }

            return differenceItems;
        }

        private static IReadOnlyCollection<PeriodActualsPaas> SplitAllocationActualsByPeriod(AllocationActualsPaas allocationActuals)
        {
            return allocationActuals.EnrichedReportedActuals
                .GroupBy(era => era.Period)
                .Select(grp => new PeriodActualsPaas(
                    key: allocationActuals.Key.ToString(),
                    contractNumber: allocationActuals.ContractNumber,
                    allocationNumber: allocationActuals.AllocationNumber,
                    versionNumber: allocationActuals.VersionNumber,
                    period: grp.Key,
                    enrichedReportedActuals: grp.ToList()))
                .ToList();
        }

        public class PeriodLevelDifferenceItem : DifferenceItem
        {
            [Order(21)]
            public string Period { get; set; }
        }
    }
}