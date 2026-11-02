namespace PaymentManagement.Calculation.Extensions
{
    using Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using System.Collections.Generic;
    using System.Linq;

    public static class ActualsSummaryTypeExtensions
    {
        public static int? CappingApportionmentPriorityOrder(this ActualsSummaryType actualsSummaryType, IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos)
        {
            return fspDeliverableInfos.SingleOrDefault(fdi => fdi.DeliverableCode == actualsSummaryType.DeliverableCode)
                ?.CappingApportionmentPriorityOrder;
        }

        public static bool IsAllowProfile(this ActualsSummaryType actualsSummaryType, IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos)
        {
            return fspDeliverableInfos.Any(fdi => fdi.DeliverableCode == actualsSummaryType.DeliverableCode && fdi.AllowProfile);
        }

        public static bool IsAllowPayment(this ActualsSummaryType actualsSummaryType, IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos)
        {
            return fspDeliverableInfos.Any(fdi => fdi.DeliverableCode == actualsSummaryType.DeliverableCode && fdi.AllowPayment);
        }

        public static int? FundingStreamPeriodCappingGroupId(this ActualsSummaryType actualsSummaryType, IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos)
        {
            return fspDeliverableInfos.SingleOrDefault(fdi => fdi.DeliverableCode == actualsSummaryType.DeliverableCode)
                ?.FundingStreamPeriodCappingGroupId;
        }
    }
}