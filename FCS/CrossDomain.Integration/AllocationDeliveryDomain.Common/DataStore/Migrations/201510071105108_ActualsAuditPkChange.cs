namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System.Configuration;
    using System.Data.Entity.Migrations;
    using System.IO;
    using System.Reflection;
    using Helpers;
    using Model;

    public partial class ActualsAuditPkChange : DbMigration
    {
        public override void Up()
        {
            Sql("ALTER TABLE [MonitoringDeliverables].[AllocationDeliverablePeriodActualAudit] DROP [PK_MonitoringDeliverables.AllocationDeliverablePeriodActualAudit]");
            Sql("ALTER TABLE [MonitoringDeliverables].[AllocationDeliverablePeriodActualAudit] ALTER COLUMN [CollectionReturnCode] [nvarchar](10) not null");
            Sql("ALTER TABLE [MonitoringDeliverables].[AllocationDeliverablePeriodActualAudit] ADD CONSTRAINT [PK_MonitoringDeliverables.AllocationDeliverablePeriodActualAudit] PRIMARY KEY ([CollectionReturnCode], [OrganisationId], [FundingStreamPeriodCode], [UopCode], [DeliverableCode], [Period])");
        }
        
        public override void Down()
        {
            Sql("ALTER TABLE [MonitoringDeliverables].[AllocationDeliverablePeriodActualAudit] DROP [PK_MonitoringDeliverables.AllocationDeliverablePeriodActualAudit]");
            Sql("ALTER TABLE [MonitoringDeliverables].[AllocationDeliverablePeriodActualAudit] ALTER COLUMN [CollectionReturnCode] [nvarchar](10) null");
            Sql("ALTER TABLE [MonitoringDeliverables].[AllocationDeliverablePeriodActualAudit] ADD CONSTRAINT [PK_MonitoringDeliverables.AllocationDeliverablePeriodActualAudit] PRIMARY KEY ([[CollectionReturnPeriod]], [OrganisationId], [FundingStreamPeriodCode], [UopCode], [DeliverableCode], [Period])");
        }
    }
}
