namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;

    public static class AllocationDeliverableExtensions
    {
        public static List<ScheduledPayment> GetDefaultScheduledPayments(
            this AllocationDeliverable allocationDeliverable,
           IReadOnlyCollection<string> periods)
        {
            return periods
                .Select(p => new ScheduledPayment
                {
                    Period = p
                }).ToList();
        }
    }
}
