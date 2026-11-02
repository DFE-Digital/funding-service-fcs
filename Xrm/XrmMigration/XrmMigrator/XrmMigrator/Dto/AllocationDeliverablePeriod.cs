namespace XrmMigrator.Dto
{
    using System;
    using Microsoft.Xrm.Sdk;

    public class AllocationDeliverablePeriod
    {
        public Guid? AllocationId { get; set; }

        public Guid? DeliverableId { get; set; }

        public Guid? DeliverablePeriodId { get; set; }

        public string DeliverableCode { get; set; }

        public string DeliverablePeriod { get; set; }

        public EntityReference ProfileSubnominalCode { get; set; }

        public EntityReference ReconcilationSubnominalCode { get; set; }

        public EntityReference CappingSubnominalCode { get; set; }
    }
}