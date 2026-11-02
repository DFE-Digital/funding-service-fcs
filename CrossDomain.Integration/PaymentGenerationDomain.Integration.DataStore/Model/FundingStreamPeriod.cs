namespace PaymentGenerationDomain.Integration.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class FundingStreamPeriod
    {
        [Key]
        [StringLength(20)]
        public string Code { get; set; }

        [Required]
        [StringLength(100)]
        public string Name { get; set; }

        [Required]
        [StringLength(100)]
        public string FundingStreamCode { get; set; }

        [ForeignKey("FundingStreamCode")]
        public virtual FundingStream FundingStream { get; set; }

        [Column(TypeName = "Date")]
        public DateTime StartDate { get; set; }

        [Column(TypeName = "Date")]
        public DateTime EndDate { get; set; }

        [Required]
        public bool ShouldGeneratePayments { get; set; }

        [StringLength(100)]
        public string FspReportingName { get; set; }
    }
}
