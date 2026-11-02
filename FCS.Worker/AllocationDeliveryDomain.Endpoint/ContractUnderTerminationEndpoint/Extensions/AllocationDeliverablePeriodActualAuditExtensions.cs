namespace AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint.Extensions
{
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;

    public static class AllocationDeliverablePeriodActualAuditExtensions
    {
        public static ActualsSummaryType ToActualsSummaryType(
            this AllocationDeliverablePeriodActualAudit deliverablePeriodActualAudit)
        {
            return new ActualsSummaryType
            {
                ActualValue = (decimal)deliverablePeriodActualAudit.ActualValue,
                ActualVolume = (int)deliverablePeriodActualAudit.ActualVolume,
                DeliverableCode = deliverablePeriodActualAudit.DeliverableCode,
                Period = deliverablePeriodActualAudit.Period,
                PeriodType = new PeriodTypeType { PeriodTypeCode = deliverablePeriodActualAudit.PeriodTypeCode }
            };
        }

        public static ActualsSummaryType ToZeroisedActualsSummaryType(
            this AllocationDeliverablePeriodActualAudit deliverablePeriodActualAudit)
        {
            return new ActualsSummaryType
            {
                DeliverableCode = deliverablePeriodActualAudit.DeliverableCode,
                Period = deliverablePeriodActualAudit.Period,
                PeriodType = new PeriodTypeType { PeriodTypeCode = deliverablePeriodActualAudit.PeriodTypeCode }
            };
        }
    }
}
