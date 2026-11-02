namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class Allocation
    {
        [Key, Column(Order = 0)]
        public string AllocationNumber { get; set; }

        [Key, Column(Order = 1)]
        public int VersionNumber { get; set; }

        [Required, MaxLength(100)]
        [Index("IX_Allocation_FundingStreamPeriodCode", IsUnique = false)]
        public string FundingStreamPeriodCode { get; set; }

        public string ContractNumber { get; set; }

        public int ContractVersionNumber { get; set; }

        public DateTime? AllocationStartDate { get; set; }

        public DateTime? AllocationEndDate { get; set; }

        //[Column(TypeName = "datetime2")]
        public DateTime? LastModifiedDate { get; set; }
    }
}
