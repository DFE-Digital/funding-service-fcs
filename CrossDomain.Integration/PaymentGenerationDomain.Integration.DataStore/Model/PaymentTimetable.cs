namespace PaymentGenerationDomain.Integration.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class PaymentTimetable
    {
        [Key]
        [Column(Order = 1)]
        [Index("IX_FundingStreamPeriodCodeAndCensusEndDate", 1, IsUnique = true)]
        public string FundingStreamPeriodCode { get; set; }

        [ForeignKey("FundingStreamPeriodCode")]
        public virtual FundingStreamPeriod FundingStreamPeriod { get; set; }

        [Key]
        [Column(Order = 2)]
        [StringLength(6)]
        public string CalendarPeriod { get; set; }

        [Required]
        [StringLength(10)]
        public string CalendarPeriodType { get; set; }

        [Index("IX_FundingStreamPeriodCodeAndCensusEndDate", 2, IsUnique = true)]
        public DateTime CensusEndDate { get; set; }

        [StringLength(6)]
        public string FinancialPeriod { get; set; }

        [Required]

        [StringLength(10)]
        public string FinancialPeriodType { get; set; }

        [Column(TypeName = "Date")]
        public DateTime PeriodStartDate { get; set; }

        [Column(TypeName = "Date")]
        public DateTime PeriodEndDate { get; set; }
        
        [Column(TypeName = "Date")]
        public DateTime PaymentDueDate { get; set; }

        [Column(TypeName = "Char")]
        [StringLength(1)]
        public string LinkCodeSuffix { get; set; }
    
        [Required]  
        [StringLength(40)]
        public string Status { get; set; }

        public override string ToString()
        {
            return $"Funding Stream Period: {FundingStreamPeriodCode}, Calendar Period: {CalendarPeriod}, Census End Date: {CensusEndDate}";
        }
    }
}
