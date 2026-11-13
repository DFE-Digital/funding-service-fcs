namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.Extensions
{
    extern alias IntegrationEntities;
    using System.Collections.Generic;
    using System.Linq;
    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;

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
