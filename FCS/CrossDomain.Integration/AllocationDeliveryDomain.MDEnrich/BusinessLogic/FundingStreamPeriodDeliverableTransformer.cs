namespace SFA.FCT.AllocationDeliveryDomain.MDEnrich.BusinessLogic
{
    using System.Collections.Generic;
    using Common.DataStore.Model;
    using CrossDomain.Integration.Entities.DeliveryAllocation;

    public static class FundingStreamPeriodDeliverableTransformer
    {
        public static contractDeliverableType TransformToContractDeliverableType(
            FundingStreamPeriodDeliverable fundingStreamPeriodDeliverable, List<contractDeliverablePeriodsTypeContractDeliverablePeriod> contractDeliverablePeriods)
        {
            return new contractDeliverableType()
            {
                deliverable = new deliverableType
                {
                    deliverableCode = fundingStreamPeriodDeliverable.DeliverableCode,
                    deliverableName = fundingStreamPeriodDeliverable.DeliverableName,
                    isLegal = false,
                    isMonitoring = true,
                    DisplayOrder = fundingStreamPeriodDeliverable.DisplayOrder
                },

                contractDeliverablePeriods = contractDeliverablePeriods
            };
        }
    }
}
