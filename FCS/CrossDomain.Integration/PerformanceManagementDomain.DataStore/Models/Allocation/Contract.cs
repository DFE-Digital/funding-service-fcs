namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation
{
    using System;
    using System.ComponentModel.DataAnnotations;
    public class Contract
    {
        [MaxLength(30)]
        [Required]
        public string ContractNumber { get; set; }

        [Required]
        public int VersionNumber { get; set; }

        [Required]
        public int SubVersionNumber { get; set; }

        [Required]
        public DateTime ApprovalDate { get; set; }
    }
}
