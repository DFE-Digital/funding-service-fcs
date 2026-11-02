namespace PerformanceManagement.IntegrationTests.PageObjects
{
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using System.Collections.Generic;

    public class DeliverableCodePayments
    {
        public DeliverableCodePayments()
        {
            Payments = new List<DeliverablePayment>();
        }

        public List<DeliverablePayment> Payments { get; set; }

        public int DeliverableCode { get; set; }

        public int? ParentDeliverableCode { get; set; }
    }
}
