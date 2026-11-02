namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Services
{
    using System.Collections.Generic;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using Allocation = CrossDomain.Integration.Entities.PaymentSchedule.Allocation;

    public class PaymentScheduleWithPayments
    {
        public PaymentScheduleWithPayments(IReadOnlyCollection<DeliverablePayment> deliverablePayments, Allocation paymentScheduleAllocation)
        {
            DeliverablePayments = deliverablePayments;
            PaymentScheduleAllocation = paymentScheduleAllocation;
        }

        public Allocation PaymentScheduleAllocation { get; }

        public IReadOnlyCollection<DeliverablePayment> DeliverablePayments { get; }
    }
}
