namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class PaymentInstructionAudit
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Column(Order = 1)]
        [Required]
        [Index("IX_PaymentInstructionAudit_Unique", Order = 3, IsUnique = true)]
        [Index("IX_PaymentInstructionAudit_ContractAllocationNumberCollectionReturnPeriod", Order = 2, IsUnique = false)]
        public int CollectionReturnPeriod { get; set; }

        [Column(Order = 2)]
        [Required]
        [StringLength(10)]
        [Index("IX_PaymentInstructionAudit_Unique", Order = 6, IsUnique = true)]
        public string OrganisationId { get; set; }

        [Column(Order = 3)]
        [Required]
        [StringLength(100)]
        [Index("IX_PaymentInstructionAudit_Unique", Order = 5, IsUnique = true)]
        public string FundingStreamPeriodCode { get; set; }

        [Column(Order = 4)]
        [Required]
        [Index("IX_PaymentInstructionAudit_Unique", Order = 4, IsUnique = true)]
        public int DeliverableCode { get; set; }

        [Column(Order = 5)]
        [Required]
        [StringLength(6)]
        [Index("IX_PaymentInstructionAudit_Unique", Order = 2, IsUnique = true)]
        public string Period { get; set; }

        [Required]
        [StringLength(20)]
        [Index("IX_PaymentInstructionAudit_Unique", Order = 1, IsUnique = true)]
        [Index("IX_PaymentInstructionAudit_ContractAllocationNumberCollectionReturnPeriod", Order = 1, IsUnique = false)]
        public string ContractAllocationNumber { get; set; }

        [StringLength(8)]
        public string Ukprn { get; set; }

        [StringLength(20)]
        public string ContractNumber { get; set; }

        public int ContractVersion { get; set; }

        public int ContractSubVersion { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime AllocationStartDate { get; set; }

        [StringLength(10)]
        public string CollectionReturnCode { get; set; }

        [StringLength(20)]
        public string CollectionType { get; set; }

        public decimal PaymentValue { get; set; }
    }
}