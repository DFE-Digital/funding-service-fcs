namespace SFA.FCT.PerformanceManagementDomain.DataStore.Models
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using Allocation;

    public class ContractAllocationDeliverable
    {
        private ContractAllocationDeliverable()
        {
        }

        public ContractAllocationDeliverable(string contractAllocationNumber, int deliverableCode, decimal plannedValue)
        {
            DeliverableCode = deliverableCode;
            ContractAllocationNumber = contractAllocationNumber;
            PlannedValue = plannedValue;
        }

        [Key, Column(Order = 0)]
        [MaxLength(20)]
        public string ContractAllocationNumber { get; private set; }

        [Key, Column(Order = 1)]
        public int DeliverableCode { get; private set; }

        public decimal? PlannedValue { get; set; }

        [ForeignKey("ContractAllocationNumber")]
        public ContractAllocation Allocation { get; set; }
    }
}
