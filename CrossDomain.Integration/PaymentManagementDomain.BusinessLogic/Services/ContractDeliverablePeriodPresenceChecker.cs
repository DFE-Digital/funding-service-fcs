namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Services
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using DTOs;
    using PaymentAggregation = CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using PaymentSchedule = CrossDomain.Integration.Entities.PaymentSchedule;

    public class ContractDeliverablePeriodPresenceChecker : IContractDeliverablePeriodPresenceChecker
    {
        public bool AreAllRequiredContractDeliverablePeriodsPresent(PaymentAggregation.Allocation allocation, IEnumerable<ContractDeliverablePeriodInfo> existingContractDeliverablePeriods)
        {
            IEnumerable<DeliverablePeriodInfo> requiredDeliverablePeriods = ExtractRequiredDeliverablePeriodsFromAllocation(allocation);

            return AreAllRequiredContractDeliverablePeriodsPresent(requiredDeliverablePeriods, existingContractDeliverablePeriods);
        }

        public bool AreAllRequiredContractDeliverablePeriodsPresent(PaymentSchedule.Allocation allocation, IEnumerable<ContractDeliverablePeriodInfo> existingContractDeliverablePeriods)
        {
            IEnumerable<DeliverablePeriodInfo> requiredDeliverablePeriods = ExtractRequiredDeliverablePeriodsFromAllocation(allocation);

            return AreAllRequiredContractDeliverablePeriodsPresent(requiredDeliverablePeriods, existingContractDeliverablePeriods);
        }

        private static IEnumerable<DeliverablePeriodInfo> ExtractRequiredDeliverablePeriodsFromAllocation(PaymentAggregation.Allocation allocation)
        {
            return allocation.AllocationPeriods.SelectMany(ap => ap.Aggregations.SelectMany(agg => agg.DeliverableDetails.Select(dd => new DeliverablePeriodInfo
            {
                DeliverableCode = dd.DeliverableCode.ToString(),
                PeriodInCrmFormat = TransformPaasPeriodToCrmFormat(ap.Period)
            })));
        }

        private static IEnumerable<DeliverablePeriodInfo> ExtractRequiredDeliverablePeriodsFromAllocation(PaymentSchedule.Allocation allocation)
        {
            return allocation.AllocationDeliverables.SelectMany(ad => ad.ScheduledPayments.Select(sp => new DeliverablePeriodInfo
            {
                DeliverableCode = ad.DeliverableCode.ToString(),
                PeriodInCrmFormat = TransformPaasPeriodToCrmFormat(sp.Period)
            }));
        }

        private static bool AreAllRequiredContractDeliverablePeriodsPresent(IEnumerable<DeliverablePeriodInfo> requiredDeliverablePeriods, IEnumerable<ContractDeliverablePeriodInfo> existingContractDeliverablePeriods)
        {
            return requiredDeliverablePeriods.All(rdp => existingContractDeliverablePeriods.Any(edp => edp.DeliverableCode == rdp.DeliverableCode && edp.PeriodName == rdp.PeriodInCrmFormat));
        }

        private static string TransformPaasPeriodToCrmFormat(string paasPeriod)
        {
            int mm = int.Parse(paasPeriod.Substring(4, 2));
            int yy = int.Parse(paasPeriod.Substring(2, 2));
            int yyyy = int.Parse(paasPeriod.Substring(0, 4));
            string monthName = new DateTime(yyyy, mm, 1).ToString("MMM", CultureInfo.InvariantCulture);

            return $"{monthName}-{yy}";
        }

        private class DeliverablePeriodInfo
        {
            public string DeliverableCode { get; set; }

            public string PeriodInCrmFormat { get; set; }
        }
    }
}