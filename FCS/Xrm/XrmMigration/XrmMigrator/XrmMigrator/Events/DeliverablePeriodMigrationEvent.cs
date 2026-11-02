namespace XrmMigrator.Events
{
    using Dto;

    public class DeliverablePeriodMigrationEvent : MigrationEventBase
    {
        public string AllocationNumber { get; set; }

        public string DeliverableCode { get; set; }

        public string Period { get; set; }

        public string SubnominalCode { get; set; }

        public SubnominalType SubnominalType { get; set; }

    }
}