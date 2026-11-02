namespace AllocationDeliveryDomain.Endpoint.BusinessLogic
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class CurrentViewActualsComponent : ICurrentViewActualsComponent
    {
        private readonly IMonitoringDeliverableStore _deliverableStore;

        public CurrentViewActualsComponent(IMonitoringDeliverableStore deliverableStore)
        {
            _deliverableStore = deliverableStore;
        }

        public List<EnrichedReportedActual> UpdateCurrentViewActualsReturningFullSetOfEnrichedActuals(
            List<EnrichedReportedActual> enrichedReportedActuals,
            ConnectionInfo connectionInfo)
        {
            if (!enrichedReportedActuals.Any())
            {
                return enrichedReportedActuals;
            }

            // Use FSP Code from first Actual to retrieve config settings for FSP
            var firstActual = enrichedReportedActuals.First();

            IEnumerable<string> contractAllocationNumbers =
                enrichedReportedActuals.Select(va => va.ContractAllocationNumber).Distinct();

            IReadOnlyCollection<CurrentViewActual> currentViewActuals =
                _deliverableStore.GetCurrentViewActualsForAllocations(contractAllocationNumbers, connectionInfo);

            IReadOnlyCollection<EnrichedReportedActual> existingCurrentViewActualsAsEnrichedReportedActuals =
                currentViewActuals.Select(TransformToEnrichedReportedActual).ToList();

            // we need to find the valid actuals that don't exist in the current view actuals and store these
            IReadOnlyCollection<EnrichedReportedActual> missingEnrichedActuals = enrichedReportedActuals
                .Except(existingCurrentViewActualsAsEnrichedReportedActuals).ToList();

            _deliverableStore.InsertCurrentViewActuals(missingEnrichedActuals.Select(TransformToCurrentViewActual), connectionInfo);

            // we then need to find the valid actuals that do exist in current view actuals and update the actual value and actual volume
            IEnumerable<EnrichedReportedActual>
                validActualsThatAreAlreadyPresentInCurrentViewActuals =
                    enrichedReportedActuals.Where(existingCurrentViewActualsAsEnrichedReportedActuals.Contains);

            validActualsThatAreAlreadyPresentInCurrentViewActuals.ToList().ForEach(va =>
                UpdateCurrentViewActualWithValuesFromEnrichedReportedActual(va,
                    GetMatchingCurrentViewActual(currentViewActuals, va)));

            _deliverableStore.Update(currentViewActuals, connectionInfo);

            // we need to the return a full set to the caller 'current view actuals' (where return code is set to the latest) plus existing 
            // missingEnrichedActuals + enrichedReportedActualsForCurrentViewActual
            existingCurrentViewActualsAsEnrichedReportedActuals.ToList().ForEach(cva =>
                cva.CollectionReturnCode = firstActual.CollectionReturnCode);

            // now add current view actuals into the gaps
            HashSet<EnrichedReportedActual> uniqueEnrichedReportedActuals = enrichedReportedActuals.ToHashSet();
            uniqueEnrichedReportedActuals.UnionWith(existingCurrentViewActualsAsEnrichedReportedActuals);

            return uniqueEnrichedReportedActuals.ToList();
        }

        private CurrentViewActual GetMatchingCurrentViewActual(IReadOnlyCollection<CurrentViewActual> currentViewActuals, EnrichedReportedActual enrichedReportedActual)
        {
            return
                currentViewActuals.Single(
                    cva => cva.DeliverableCode == int.Parse(enrichedReportedActual.DeliverableCode) &&
                           cva.OrganisationId == enrichedReportedActual.OrganisationId &&
                           cva.FundingStreamPeriodCode == enrichedReportedActual.FundingStreamPeriodCode &&
                           cva.UoPCode == enrichedReportedActual.UoPCode &&
                           cva.Period == enrichedReportedActual.Period);
        }

        private void UpdateCurrentViewActualWithValuesFromEnrichedReportedActual(EnrichedReportedActual enrichedReportedActual, CurrentViewActual currentViewActual)
        {
            currentViewActual.ActualValue = enrichedReportedActual.ActualValue;
            currentViewActual.ActualVolume = enrichedReportedActual.ActualVolume;
        }

        private CurrentViewActual TransformToCurrentViewActual(EnrichedReportedActual enrichedReportedActual)
        {
            return new CurrentViewActual
            {
                Ukprn = enrichedReportedActual.Ukprn,
                ContractNumber = enrichedReportedActual.ContractNumber,
                ContractVersion = enrichedReportedActual.ContractVersion,
                ContractSubVersion = enrichedReportedActual.ContractSubVersion,
                AllocationStartDate = enrichedReportedActual.AllocationStartDate,
                AllocationEndDate = enrichedReportedActual.AllocationEndDate,
                CollectionReturnCode = enrichedReportedActual.CollectionReturnCode,
                OrganisationId = enrichedReportedActual.OrganisationId,
                PeriodTypeCode = enrichedReportedActual.PeriodTypeCode,
                Period = enrichedReportedActual.Period,
                FundingStreamPeriodCode = enrichedReportedActual.FundingStreamPeriodCode,
                CollectionType = enrichedReportedActual.CollectionType,
                ContractAllocationNumber = enrichedReportedActual.ContractAllocationNumber,
                UoPCode = enrichedReportedActual.UoPCode,
                DeliverableCode = int.Parse(enrichedReportedActual.DeliverableCode),
                ActualVolume = enrichedReportedActual.ActualVolume,
                ActualValue = enrichedReportedActual.ActualValue
            };
        }

        private EnrichedReportedActual TransformToEnrichedReportedActual(
            CurrentViewActual currentViewActual)
        {
            return new EnrichedReportedActual
            {
                Ukprn = currentViewActual.Ukprn,
                ActualValue = currentViewActual.ActualValue,
                ActualVolume = currentViewActual.ActualVolume,
                AllocationEndDate = currentViewActual.AllocationEndDate,
                AllocationStartDate = currentViewActual.AllocationStartDate,
                CollectionReturnCode = currentViewActual.CollectionReturnCode,
                CollectionType = currentViewActual.CollectionType,
                ContractAllocationNumber = currentViewActual.ContractAllocationNumber,
                ContractNumber = currentViewActual.ContractNumber,
                ContractSubVersion = currentViewActual.ContractSubVersion,
                ContractVersion = currentViewActual.ContractVersion,
                FundingStreamPeriodCode = currentViewActual.FundingStreamPeriodCode,
                OrganisationId = currentViewActual.OrganisationId,
                Period = currentViewActual.Period,
                UoPCode = currentViewActual.UoPCode,
                PeriodTypeCode = currentViewActual.PeriodTypeCode,
                DeliverableCode = currentViewActual.DeliverableCode.ToString()
            };
        }
    }
}
