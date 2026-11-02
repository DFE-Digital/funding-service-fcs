namespace XrmMigrator.Events
{
    public class DeliverableMigrationEvent : MigrationEventBase
    {
        public string AllocationNumber { get; set; }

        public string DeliverableCode { get; set; }
    }
}