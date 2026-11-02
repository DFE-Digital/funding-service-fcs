namespace PaymentGenerationDomain.Integration.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class PaymentTimetableHistory
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        public DateTime HistoryTime { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        [StringLength(6)]
        public string CalendarPeriod { get; set; }

        [Required]
        [StringLength(255)]
        public string Description { get; set; }
    }
}
