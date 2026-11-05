namespace SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule
{
    using System.Collections.Generic;
    using System.Xml.Serialization;

    [System.Diagnostics.CodeAnalysis.ExcludeFromCodeCoverage]
    public class AllocationDeliverable
    {
        public AllocationDeliverable()
        {
            ScheduledPayments = new List<ScheduledPayment>();
        }

        public int DeliverableCode { get; set; }

        [XmlArrayItem("ScheduledPayment", IsNullable = false)]
        public List<ScheduledPayment> ScheduledPayments { get; set; }
    }
}