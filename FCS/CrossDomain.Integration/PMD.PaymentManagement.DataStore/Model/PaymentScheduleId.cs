namespace SFA.FCT.PMD.PaymentManagment.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;

    public class PaymentScheduleId
    {
        [Key]
        public Guid CorrelationId { get; set; }

        public DateTime CreatedDate { get; set; }
    }
}
