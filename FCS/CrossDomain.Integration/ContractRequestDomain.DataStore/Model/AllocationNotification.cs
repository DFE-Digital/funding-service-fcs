namespace SFA.FCT.ContractRequestDomain.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class AllocationNotification
    {
        [Key]
        public int Id { get;  set; }

        [Required]
        [MaxLength(100)]
        [Index("IX_AllocationNotification_AllocationVersion", IsUnique = true, Order = 0)]
        public string AllocationId { get; set; }

        [Required]
        [Index("IX_AllocationNotification_AllocationVersion", IsUnique = true, Order = 1)]
        public int VersionNumber { get; set; }

        [Required]
        public int Ukprn { get; set; }

        [Required]
        public ProcessingStatus Status { get; set; }

        [Required]
        public int FeedPageNumber { get; set; }
    }

    public enum ProcessingStatus
    {
        New,
        Processing,
        Complete
    }
}
