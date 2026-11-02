namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories;

    public static class PaymentScheduleExtensions
    {
        public static IReadOnlyCollection<DeliverablePeriodYear> ToDeliverablePeriodYears(
            this Allocation paymentScheduleAllocation)
        {
            return paymentScheduleAllocation.AllocationDeliverables
                .SelectMany(d =>
                {
                    var scheduledPayments = d.ScheduledPayments;
                    return scheduledPayments.Select(sp => ToDeliverablePeriodYear(sp, d.DeliverableCode));
                })
                .ToList();
        }

        private static DeliverablePeriodYear ToDeliverablePeriodYear(ScheduledPayment scheduledPayment, int deliverableCode)
        {
            int period = int.Parse(scheduledPayment.Period.Substring(4, 2));
            int year = int.Parse(scheduledPayment.Period.Substring(0, 4));

            return new DeliverablePeriodYear(period, scheduledPayment.Period, year, deliverableCode.ToString(), scheduledPayment);
        }
    }
}
