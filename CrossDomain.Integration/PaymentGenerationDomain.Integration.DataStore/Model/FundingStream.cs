namespace PaymentGenerationDomain.Integration.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;

    public class FundingStream
    {
        [Key]
        [StringLength(100)]
        public string Code { get; set; }

        [Required]
        [StringLength(100)]
        public string Name { get; set; }

        [StringLength(100)]
        public string FinanceShortCode { get; set; }

        [Required]
        [StringLength(100)]
        public string AgencyCode { get; set; }
    }
}
