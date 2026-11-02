namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class AllocationDeliverablePeriod
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Index("IX_AllocationDeliverablePeriod_FspOrgUop", Order = 2, IsUnique = false)]
        [Column(Order = 1)]
        [StringLength(10)]
        [Required]
        public string OrganisationId { get; set; }

        [Index("IX_AllocationDeliverablePeriod_FspOrgUop", Order = 1, IsUnique = false)]
        [Column(Order = 2)]
        [StringLength(100)]
        [Required]
        public string FundingStreamPeriodCode { get; set; }

        [Index("IX_AllocationDeliverablePeriod_FspOrgUop", Order = 3, IsUnique = false)]
        [Column(Order = 3)]
        [StringLength(100)]
        [Required(AllowEmptyStrings = true)]
        public string UopCode { get; set; }

        [Index("IX_AllocationDeliveryPeriod_AllocationRefPeriodDeliverableCode", Order = 2, IsUnique = true)]
        [Column(Order = 4)]
        [Required]
        public int DeliverableCode { get; set; }

        [Index("IX_AllocationDeliveryPeriod_AllocationRefPeriodDeliverableCode", Order = 3, IsUnique = true)]
        [Column(Order = 5)]
        [StringLength(6)]
        [Required]
        public string Period { get; set; }

        [Index("IX_AllocationDeliveryPeriod_AllocationRefPeriodDeliverableCode", Order = 1, IsUnique = true)]
        [StringLength(20)]
        [Required]
        public string ContractAllocationNumber { get; set; }

        [StringLength(20)]
        public string ContractNumber { get; set; }

        public int ContractVersionNumber { get; set; }

        public int ContractSubVersionNumber { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime AllocationStartDate { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime? AllocationEndDate { get; set; }

        [StringLength(8)]
        public string Ukprn { get; set; }
    }
}
