namespace SFA.FCT.Operations.Integrity.IntegrityCheckers
{
    using System.Collections.Generic;
    using System.Data.Common;
    using System.Linq;
    using AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using DTOs;
    using Framework.Logging.Interfaces;
    using global::AllocationDeliveryDomain.Endpoint.Repositories;
    using Repositories;
    using ClosedCollectionRepository = Repositories.ClosedCollectionRepository;

    public class AllocationLevelSummarisedActualsToDeliverablePaymentActualChecker
        : SummarisedActualsToDeliverablePaymentActualChecker<AllocationLevelSummarisedActualsToDeliverablePaymentActualChecker.AllocationLevelDifferenceItem>
    {
        private readonly PaasDeliverablePaymentLazyRepository _paasDeliverablePaymentLazyRepository;
        private readonly ActualAuditRepository _actualAuditRepository;

        public AllocationLevelSummarisedActualsToDeliverablePaymentActualChecker(
            PaasDeliverablePaymentLazyRepository paasDeliverablePaymentLazyRepository,
            ActualAuditRepository actualAuditRepository,
            global::SFA.FCT.Operations.Integrity.Repositories.SummarisedActualRepository summarisedActualRepository,
            ClosedCollectionRepository closedCollectionRepository,
            ILogger logger,
            IMonitoringDeliverablesRepository monitoringDeliverablesRepository,
            IPaasFundingStreamPeriodRepository paasFundingStreamPeriodRepository,
            DbConnection connection,
            IAllocationsUnderTerminationQueryRepository allocationsUnderTerminationRepository,
            IFundingStreamConfigurationStore fundingStreamConfigurationStore)
            : base(summarisedActualRepository, closedCollectionRepository, logger, monitoringDeliverablesRepository, paasFundingStreamPeriodRepository, connection, allocationsUnderTerminationRepository, fundingStreamConfigurationStore)
        {
            _paasDeliverablePaymentLazyRepository = paasDeliverablePaymentLazyRepository;
            _actualAuditRepository = actualAuditRepository;
        }

        protected override IEnumerable<string> CollectionTypesToValidate => new[] { "APPS", "ESF", "ILR1920", "NCS1920", "NCS2021", "SB" };

        protected override IReadOnlyCollection<AllocationLevelDifferenceItem> GetDifferencesItemsForAllocation(AllocationActualsPaas allocationActuals)
        {
            var differenceItems = new List<AllocationLevelDifferenceItem>();

            var paasActualValue = _paasDeliverablePaymentLazyRepository.SumActualValuesForAllocation(allocationActuals.AllocationNumber, allocationActuals.VersionNumber);
            var paasActualVolume = _paasDeliverablePaymentLazyRepository.SumActualVolumesForAllocation(allocationActuals.AllocationNumber, allocationActuals.VersionNumber);

            if (allocationActuals.GetTotalActualValue() != paasActualValue || allocationActuals.GetTotalActualVolume() != paasActualVolume)
            {
                var currentAllocationVersion = allocationActuals.EnrichedReportedActuals.First().ContractVersion;
                var allocationVersionAtTimeOfCollection = GetAllocationVersionAtTimeOfCollection(allocationActuals);
                var hasAllocationBeenAmendedSinceCollection = currentAllocationVersion > allocationVersionAtTimeOfCollection;

                if (!hasAllocationBeenAmendedSinceCollection)
                {
                    differenceItems.Add(new AllocationLevelDifferenceItem
                    {
                        Key = allocationActuals.Key.ToString(),
                        ContractNumber = allocationActuals.ContractNumber,
                        AllocationNumber = allocationActuals.AllocationNumber,
                        VersionNumber = allocationActuals.VersionNumber,
                        ReportedActualValue = allocationActuals.GetTotalActualValue(),
                        ReportedActualVolume = allocationActuals.GetTotalActualVolume(),
                        PaasActualValue = paasActualValue,
                        PaasActualVolume = paasActualVolume,
                        Message = "Differences in values between SummarisedActuals and PaaS"
                    });
                }
            }

            return differenceItems;
        }

        private int GetAllocationVersionAtTimeOfCollection(AllocationActualsPaas allocationActuals)
        {
            var collectionType = allocationActuals.EnrichedReportedActuals.First().CollectionType;
            var collectionReturnCode = allocationActuals.EnrichedReportedActuals.First().CollectionReturnCode;

            var allocationVersionAtCollectionReturn = _actualAuditRepository.GetAllocationVersionAtCollectionReturn(
                allocationActuals.AllocationNumber, collectionType, collectionReturnCode);

            return allocationVersionAtCollectionReturn;
        }

        public class AllocationLevelDifferenceItem : DifferenceItem
        {
        }
    }
}