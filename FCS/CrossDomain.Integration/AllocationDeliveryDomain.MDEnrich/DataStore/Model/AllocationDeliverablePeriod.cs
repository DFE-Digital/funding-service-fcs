namespace SFA.FCT.AllocationDeliveryDomain.MDEnrich.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class AllocationDeliverablePeriod
    {
        [Key]
        [Column(Order = 1)]
        [StringLength(10)]
        public string OrganisationId { get; set; }

        [Key]
        [Column(Order = 2)]
        [StringLength(100)]
        public string FundingStreamPeriodCode { get; set; }

        [Key]
        [Column(Order = 3)]
        [StringLength(100)]
        public string UopCode { get; set; }

        [Key]
        [Column(Order = 4)]
        public int DeliverableCode { get; set; }

        [Key]
        [Column(Order=5)]
        [StringLength(6)]
        public string Period { get; set; }

        [StringLength(20)]
        public string ContractAllocationNumber { get; set; }

        [StringLength(20)]
        public string ContractNumber { get; set; }

        public int ContractVersionNumber { get; set; }

        public int ContractSubVersionNumber { get; set; }

        public DateTime AllocationStartDate { get; set; }

        public DateTime AllocationEndDate { get; set; }

        [StringLength(8)]
        public string Ukprn { get; set; }
    
    }
}
