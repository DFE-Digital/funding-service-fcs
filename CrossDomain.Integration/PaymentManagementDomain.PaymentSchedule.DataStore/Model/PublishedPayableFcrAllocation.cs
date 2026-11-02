namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;

    public class PublishedPayableFcrAllocation
    {
        private PublishedPayableFcrAllocation()
        {
        }

        public PublishedPayableFcrAllocation(string allocationNumber)
        {
            AllocationNumber = allocationNumber;
        }

        [Key]
        [MaxLength(20)]
        public string AllocationNumber { get; set; }
    }
}
