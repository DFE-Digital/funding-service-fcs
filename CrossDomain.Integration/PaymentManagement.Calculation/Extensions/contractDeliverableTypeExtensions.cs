namespace PaymentManagement.Calculation.Extensions
{
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using System.Collections.Generic;
    using System.Linq;

    public static class contractDeliverableTypeExtensions
    {
        public static int? CappingApportionmentPriorityOrder(this contractDeliverableType contractDeliverableType, IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos)
        {
            return fspDeliverableInfos.SingleOrDefault(fdi => fdi.DeliverableCode == contractDeliverableType.deliverable.deliverableCode)
                ?.CappingApportionmentPriorityOrder;
        }

        public static bool IsAllowProfile(this contractDeliverableType contractDeliverableType, IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos)
        {
            return fspDeliverableInfos.Any(fdi => fdi.DeliverableCode == contractDeliverableType.deliverable.deliverableCode && fdi.AllowProfile);
        }

        public static bool IsAllowPayment(this contractDeliverableType contractDeliverableType, IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos)
        {
            return fspDeliverableInfos.Any(fdi => fdi.DeliverableCode == contractDeliverableType.deliverable.deliverableCode && fdi.AllowPayment);
        }

        public static int? FundingStreamPeriodCappingGroupId(this contractDeliverableType contractDeliverableType, IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos)
        {
            return fspDeliverableInfos.SingleOrDefault(fdi => fdi.DeliverableCode == contractDeliverableType.deliverable.deliverableCode)
                ?.FundingStreamPeriodCappingGroupId;
        }
    }
}