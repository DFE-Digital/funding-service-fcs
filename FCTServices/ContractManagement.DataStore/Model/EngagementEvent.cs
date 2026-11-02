namespace ContractManagement.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class EngagementEvent
    {
        public const string ValidEventType = "INITIATED";
        public EngagementEvent()
        {
            // this is for Entity Framework only            
        }

        public EngagementEvent(long eventId, string eventType, string providerId)
        {
            EventId = eventId;
            EventType = eventType;
            ProviderId = providerId;
            ProcessingState = EngagementEventProcessingState.InFlight;
        }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public long EventId { get; set; }

        [Required]
        [MaxLength(30)]
        public string EventType { get; set; }

        [Index("IX_EngagementEvent_ProviderId")]
        [MaxLength(10)]
        public string ProviderId { get; set; }

        [Required]
        [DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        public DateTime CreatedDate { get; set; }

        [Required]
        public EngagementEventProcessingState ProcessingState { get; set; }

        [MaxLength(20)]
        public string ContractNumber { get; set; }

        [NotMapped]
        public bool IsValid { get; set; }

        [NotMapped]
        public string ValidationError { get; set; }

        public override bool Equals(object obj)
        {
            EngagementEvent otherEngagementEvent = obj as EngagementEvent;
            return otherEngagementEvent != null && otherEngagementEvent.EventId == this.EventId;
        }

        public override int GetHashCode()
        {
            return EventId.GetHashCode();
        }
    }
}
