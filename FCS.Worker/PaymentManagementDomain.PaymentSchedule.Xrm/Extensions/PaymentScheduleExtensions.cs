namespace PaymentManagementDomain.PaymentSchedule.Xrm.Extensions
{
    extern alias IntegrationEntities;
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories;

    public static class PaymentScheduleExtensions
    {
        public static bool AreAllDeliverablePeriodsPresent(this Allocation paymentScheduleAllocation,
            IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYears,
            DateTime allocationStartDate, DateTime allocationEndDate)
        {
            List<DeliverablePeriodYear> paymentScheduleDeliverablePeriodYears = paymentScheduleAllocation.AllocationDeliverables
                .SelectMany(ad => ad.TransformAllocationDeliverableToDeliverablePeriodYears())
                .Where(dpy => DeliverablePeriodInAllocationDateRange(dpy, allocationStartDate, allocationEndDate))
                .ToList();

            return paymentScheduleDeliverablePeriodYears.All(deliverablePeriodYears.Contains);
        }

        private static bool DeliverablePeriodInAllocationDateRange(DeliverablePeriodYear deliverablePeriodYear, DateTime allocationStartDate, DateTime allocationEndDate)
        {
            var periodDate = new DateTime(deliverablePeriodYear.Year.Value, deliverablePeriodYear.Period.Value, 1);

            return periodDate >= allocationStartDate && periodDate <= allocationEndDate;
        }

        private static List<DeliverablePeriodYear> TransformAllocationDeliverableToDeliverablePeriodYears(this AllocationDeliverable allocationDeliverable)
        {
            var deliverableCode = allocationDeliverable.DeliverableCode;

            return allocationDeliverable.ScheduledPayments
                .Select(sd => TransformToDeliverablePeriodYear(sd, deliverableCode)).ToList();
        }

        private static DeliverablePeriodYear TransformToDeliverablePeriodYear(this ScheduledPayment scheduledPayment, int deliverableCode)
        {
            int month = int.Parse(scheduledPayment.Period.Substring(4, 2));
            string year = scheduledPayment.Period.Substring(0, 4);

            return new DeliverablePeriodYear(
                period: month,
                periodName: GetFormattedPeriod(month, year),
                year: int.Parse(year),
                deliverableCode: deliverableCode.ToString());

                // CRM column       = CRM Display name  = sample transform value from 201808
                // sfa_Period       = period number     = 8
                // sfa_PeriodName   = period            = Aug-18
                // sfa_Year         = Year              = 2018
        }

        private static string GetFormattedPeriod(int month, string year)
        {
            return $"{DateTimeFormatInfo.InvariantInfo.GetAbbreviatedMonthName(month)}-{year.Substring(2, 2)}";
        }
    }
}
