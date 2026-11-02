namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class AllocationUnderTermination
    {
        // this ctor is for EF
        private AllocationUnderTermination()
        {
        }

        public AllocationUnderTermination(string contractNumber, string contractAllocationNumber, DateTime terminationDate)
        {
            ContractAllocationNumber = contractAllocationNumber;
            TerminationDate = terminationDate;
            ContractNumber = contractNumber;
        }

        [Key]
        [StringLength(50)]
        public string ContractAllocationNumber { get; private set; }

        [Required]
        public DateTime TerminationDate { get; private set; }

        [Index("IX_ContractNumber", IsUnique = false)]
        [Required]
        [StringLength(20)]
        public string ContractNumber { get; private set; }
    }
}