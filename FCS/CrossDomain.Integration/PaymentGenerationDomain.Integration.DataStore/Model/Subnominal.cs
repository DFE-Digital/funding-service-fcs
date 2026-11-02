namespace PaymentGenerationDomain.Integration.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;

    public class Subnominal
    {
        [Key]
        [StringLength(8)]
        public string Code { get; set; }

        [Required]
        [StringLength(100)]
        public string ShortDescription { get; set; }
    }
}
