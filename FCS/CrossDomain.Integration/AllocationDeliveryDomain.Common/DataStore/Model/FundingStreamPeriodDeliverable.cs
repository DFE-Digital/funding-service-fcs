namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class FundingStreamPeriodDeliverable
    {
        [Key]
        [Column(Order = 1)]
        [StringLength(100)]
        public string FundingStreamPeriodCode { get; set; }

        [Key]
        [Column(Order = 2)]
        public int DeliverableCode { get; set; }

        public int ParentDeliverableCode { get; set; }

        [Required]
        [StringLength(100)]
        public string DeliverableName { get; set; }

        public bool AllowProfile { get; set; }

        /// <summary>
        /// This is true for monitoring deliverables
        /// </summary>
        public bool AllowActuals { get; set; }

        public bool AllowPayment { get; set; }

        [Required]
        [Column(Order = 8)]
        public int DisplayOrder { get; set; }

        public bool IsAllowedToBeAdded { get; set; }
    }
}