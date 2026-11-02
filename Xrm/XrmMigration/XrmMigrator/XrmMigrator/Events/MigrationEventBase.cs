namespace XrmMigrator.Events
{
    public abstract class MigrationEventBase
    {
        public string Message { get; set; }
        public int Processed { get; set; }
        public EventResult Result { get; set; }
        public EventType Type { get; set; }
    }
}