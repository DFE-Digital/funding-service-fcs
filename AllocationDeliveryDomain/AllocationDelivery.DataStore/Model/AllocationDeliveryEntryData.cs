namespace SFA.FCT.AllocationDelivery.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class AllocationDeliveryEntryData
    {
        [Key]
        public int EntryID { get; set; }

        [Required]
        [ForeignKey("EntryID")]
        public AllocationDeliveryEntry AllocationDeliveryEntry { get; set; }

        [Required]
        public byte[] CorporateAllocationDeliveryBytes { get; set; }
    }
}
