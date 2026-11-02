namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class RemoveParentDeliverableCode : DbMigration
    {
        public override void Up()
        {
            DropColumn("MonitoringDeliverables.PaymentInstructionAudit", "ParentDeliverableCode");
        }
        
        public override void Down()
        {
            AddColumn("MonitoringDeliverables.PaymentInstructionAudit", "ParentDeliverableCode", c => c.Int(nullable: false));
        }
    }
}
