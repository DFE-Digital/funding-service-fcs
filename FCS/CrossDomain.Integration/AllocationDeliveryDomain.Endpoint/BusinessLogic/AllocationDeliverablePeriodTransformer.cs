namespace AllocationDeliveryDomain.Endpoint.BusinessLogic
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;

    public static class AllocationDeliverablePeriodTransformer
    {
        public static IEnumerable<EnrichedReportedActual> ToEnrichedReportedActuals(
            IEnumerable<AllocationDeliverablePeriod> allocationDeliverablePeriods, EnrichedReportedActual validEnrichedReportedActual)
        {
            var transformedEnrichedReportedActuals = new List<EnrichedReportedActual>();
            
            allocationDeliverablePeriods.ToList().ForEach(adp =>
            {
                transformedEnrichedReportedActuals.Add(TransformToZeroValueEnrichedReportedActual(adp, validEnrichedReportedActual));
            });

            return transformedEnrichedReportedActuals;
        }

        private static EnrichedReportedActual TransformToZeroValueEnrichedReportedActual(AllocationDeliverablePeriod adp, EnrichedReportedActual validEnrichedReportedActual)
        {
            // Perform first mapping to populate enriched actual properties.
            var transformedActual = validEnrichedReportedActual.ShallowClone();

            transformedActual.UpdateFieldsFrom(adp);
            transformedActual.ActualValue = 0;
            transformedActual.ActualVolume = 0;

            return transformedActual;
        }
    }
}
