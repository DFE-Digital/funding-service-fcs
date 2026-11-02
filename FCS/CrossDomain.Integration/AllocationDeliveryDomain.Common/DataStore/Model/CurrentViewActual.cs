namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class CurrentViewActual
    {
        [StringLength(8)]
        [Column(Order = 1)]
        public string Ukprn { get; set; }

        [StringLength(20)]
        [Column(Order = 2)]
        public string ContractNumber { get; set; }

        [Column(Order = 3)]
        public int ContractVersion { get; set; }

        [Column(Order = 4)]
        public int ContractSubVersion { get; set; }

        [Column(TypeName = "datetime2", Order = 5)]
        public DateTime AllocationStartDate { get; set; }

        [Column(TypeName = "datetime2", Order = 6)]
        public DateTime AllocationEndDate { get; set; }

        [StringLength(10)]
        [Column(Order = 7)]
        public string CollectionReturnCode { get; set; }

        //[Key]
        [Index("IX_OrgIdPeriodFSPCUoPDeliverableCode", 1, IsUnique = true)]
        [StringLength(10)]
        [Column(Order = 8)]
        [Required]
        public string OrganisationId { get; set; }

        [StringLength(2)]
        [Column(Order = 9)]
        public string PeriodTypeCode { get; set; }

        //[Key]
        [Index("IX_OrgIdPeriodFSPCUoPDeliverableCode", 2, IsUnique = true)]
        [StringLength(6)]
        [Column(Order = 10)]
        [Required]
        public string Period { get; set; }

        //[Key]
        [Index ("IX_OrgIdPeriodFSPCUoPDeliverableCode", 3, IsUnique = true)]
        [StringLength(20)]
        [Column(Order = 11)]
        [Required]
        public string FundingStreamPeriodCode { get; set; }

        [StringLength(20)]
        [Column(Order = 12)]
        public string CollectionType { get; set; }

        [Index("IX_OrgIdPeriodFSPCUoPDeliverableCode", 4, IsUnique = true)]
        [StringLength(20)]
        [Column(Order = 13)]
        public string ContractAllocationNumber { get; set; }

        //[Key]
        [Index("IX_OrgIdPeriodFSPCUoPDeliverableCode", 5, IsUnique = true)]
        [StringLength(100)]
        [Column(Order = 14)]
        [Required (AllowEmptyStrings = true)]
        public string UoPCode { get; set; }

        //[Key]
        [Index("IX_OrgIdPeriodFSPCUoPDeliverableCode", 6, IsUnique = true)]
        [Column(Order = 15)]
        [Required]
        public int DeliverableCode { get; set; }

        [Column(Order = 16)]
        public long ActualVolume { get; set; }

        [Column(Order = 17)]
        public double ActualValue { get; set; }

        // can't use Order = 18, because of migration-added, but missing from model, CreatedDate
        [Column(TypeName = "datetime2")]
        public DateTime? LastModifiedDate { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        [Key]
        public int Id { get; set; }

    }
}