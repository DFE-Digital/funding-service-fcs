namespace SFA.FCT.PMD.PaymentManagment.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;

    public class PaymentAggregationXRMId
    {
        [Key]
        public Guid CorrelationId { get; set; }

        public DateTime CreatedDate { get; set; }
    }
}
