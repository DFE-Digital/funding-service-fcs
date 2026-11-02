namespace ContractManagement.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class ApprovedContractDeliverable
    {
        private ApprovedContractDeliverable()
        {
        }

        public ApprovedContractDeliverable(
            string contractAllocationNumber,
            int deliverableCode, 
            decimal totalPlannedValue,
            decimal? plannedValueEnvelope1,
            decimal? plannedValueEnvelope2)
        {
            ContractAllocationNumber = contractAllocationNumber;
            DeliverableCode = deliverableCode;
            TotalPlannedValue = totalPlannedValue;
            PlannedValueEnvelope1 = plannedValueEnvelope1;
            PlannedValueEnvelope2 = plannedValueEnvelope2;
        }

        public ApprovedContractDeliverable(
            string contractAllocationNumber,
            int approvedContractId,
            int deliverableCode,
            decimal totalPlannedValue,
            decimal? plannedValueEnvelope1,
            decimal? plannedValueEnvelope2) :this(contractAllocationNumber, deliverableCode, totalPlannedValue, plannedValueEnvelope1, plannedValueEnvelope2)
        {
            ApprovedContractId = approvedContractId;
        }

        [Key, Column(Order = 0)]
        [StringLength(50)]
        public string ContractAllocationNumber { get; private set; }

        [Key, Column(Order = 1)]
        public int ApprovedContractId { get; private set; }

        [Key, Column(Order = 2)]
        public int DeliverableCode { get; private set; }

        public decimal TotalPlannedValue { get; private set; }

        public decimal? PlannedValueEnvelope1 { get; private set; }

        public decimal? PlannedValueEnvelope2 { get; private set; }

        [ForeignKey("ContractAllocationNumber, ApprovedContractId")]
        public virtual ApprovedContractAllocation Parent { get; set; }
    }
}
