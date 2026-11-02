namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using DTOs;
    using SFA.FCT.CrossDomain.Integration.Common.Extensions;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;

    public static class DeliverableLinesExtensions
    {
        public static decimal GetSumOfParentDeliverablesPlannedValueForGroup(
            this IReadOnlyCollection<DeliverableLine> deliverableLines,
            IReadOnlyCollection<DeliverableCodeInfo> deliverableCodeInfos)
        {
            if (deliverableLines.Empty())
            {
                return 0;
            }

            var deliverableLinesWithParents = deliverableLines.Select(dl =>
            {
                var deliverableInfo = deliverableCodeInfos.Single(delInfo => delInfo.DeliverableCode == dl.DeliverableCode);

                return new
                {
                    dl,
                    deliverableInfo.ParentDeliverableCode,
                    deliverableInfo.AllowProfile,
                    deliverableInfo.ClaimReconciliationDeliverableGroupCode
                };
            }).ToList();

            bool areAllParentPlannedValuesTrusted = deliverableCodeInfos.All(dcInfo => !string.IsNullOrEmpty(dcInfo.ClaimReconciliationDeliverableGroupCode));

            if (areAllParentPlannedValuesTrusted || deliverableLinesWithParents.Any(dl => !dl.dl.PlannedValue.HasValue))
            {
                var parentDeliverableGrps = deliverableLinesWithParents
                    .Where(dl => dl.ParentDeliverableCode.HasValue)
                    .GroupBy(dl => dl.ParentDeliverableCode);

                return parentDeliverableGrps.Sum(grp => grp.First().dl.ParentPlannedValue) ?? 0;
            }

            var deliverablesWithProfile = deliverableLinesWithParents.Where(dlp => dlp.AllowProfile).ToList();
            if (deliverablesWithProfile.Any())
            {
                return deliverablesWithProfile.GroupBy(dl => dl.ParentDeliverableCode)
                    .Sum(parentDeliverableGrp =>
                    {
                        if (parentDeliverableGrp.Any(grp => grp.dl.PlannedValue.GetValueOrDefault() > 0))
                        {
                            return parentDeliverableGrp.Sum(pd => pd.dl.PlannedValue);
                        }

                        return parentDeliverableGrp.First().dl.ParentPlannedValue;

                    }) ?? 0; 
            }

            return deliverableLinesWithParents.First().dl.ParentPlannedValue ?? 0;
        }
    }
}
