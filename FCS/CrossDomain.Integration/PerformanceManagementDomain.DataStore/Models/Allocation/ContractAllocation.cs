namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public class ContractAllocation
    {
        private ContractAllocation()
        {
        }

        public ContractAllocation(string allocationNumber, DateTime startDate, DateTime? endDate)
        {
            AllocationNumber = allocationNumber;
            StartDate = startDate;
            EndDate = endDate;
        }

        [Key]
        [MaxLength(30)]
        public string AllocationNumber { get; private set; }
        
        public DateTime StartDate { get; set; }

        [Required]
        public DateTime? EndDate { get; set; }

        public Contract Contract { get; set; }

        public Contractor Contractor { get; set; }

        public FundingType FundingType { get; set; }

        public Period Period { get; set; }

        public DateTime? LastModifiedDate { get; set; }

        public virtual ICollection<ContractAllocationDeliverable> ContractAllocationDeliverables { get; private set; }
    }
}
