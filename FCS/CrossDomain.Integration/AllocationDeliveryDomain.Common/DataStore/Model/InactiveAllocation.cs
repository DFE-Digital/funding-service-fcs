namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;

    public class InactiveAllocation
    {
        private InactiveAllocation()
        {
        }

        public InactiveAllocation(
            string contractAllocationNumber,
            InactiveReason reason)
        {
            ContractAllocationNumber = contractAllocationNumber;
            Reason = reason;
        }


        [Key]
        [StringLength(50)]
        public string ContractAllocationNumber { get; private set; }

        [Required]
        public InactiveReason Reason { get; private set; }
    }
}