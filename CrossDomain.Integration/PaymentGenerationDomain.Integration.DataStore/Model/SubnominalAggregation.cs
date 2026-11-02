namespace PaymentGenerationDomain.Integration.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class SubnominalAggregation
    {   
        [Key]
        [Column(Order = 1)]
        [StringLength(20)]
        public string AllocationNumber { get; set; }

        [Index("IX_FundingStreamPeriodCodePeriod", 1, IsUnique = false)]
        [StringLength(20)]
        public string FundingStreamPeriodCode { get; set; }

        [ForeignKey("FundingStreamPeriodCode")]
        public virtual FundingStreamPeriod FundingStreamPeriod { get; set; }

        [Index("IX_FundingStreamPeriodCodePeriod", 2, IsUnique = false)]
        [Key]
        [Column(Order = 2)]
        [StringLength(6)]
        public string Period { get; set; }

        [Key]
        [Column(Order = 3)]
        [StringLength(8)]
        public string SubnominalCode { get; set; }

        [ForeignKey("SubnominalCode")]
        public virtual Subnominal Subnominal { get; set; }

        [Key]
        [Column(Order = 4)]
        [StringLength(20)]
        public string PaymentType { get; set; }

        [Column(Order = 7)]
        [StringLength(10)]
        public string PeriodTypeCode { get; set; }

        [Column(Order = 8)]
        [StringLength(10)]
        public string OrganisationId { get; set; }

        public int Ukprn { get; set; }

        public bool PostedFlag { get; set; }

        public decimal AggregatedValue { get; set; }

        public bool IsSelectedForPayment { get; set; }

        public DateTime? LastModifiedDate { get; set; }

        [Required]
        public int AllocationVersionNumber { get; set; }
    }
}
