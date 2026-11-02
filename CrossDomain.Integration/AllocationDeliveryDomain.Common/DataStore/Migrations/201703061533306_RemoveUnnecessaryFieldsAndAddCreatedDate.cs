namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class RemoveUnnecessaryFieldsAndAddCreatedDate : DbMigration
    {
        public override void Up()
        {
            DropColumn("MonitoringDeliverables.PaymentInstructionAudit", "AllocationEndDate");
            DropColumn("MonitoringDeliverables.PaymentInstructionAudit", "PeriodTypeCode");
            AddColumn("MonitoringDeliverables.PaymentInstructionAudit", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETDATE()"));
        }
        
        public override void Down()
        {
            AddColumn("MonitoringDeliverables.PaymentInstructionAudit", "PeriodTypeCode", c => c.String(maxLength: 2));
            AddColumn("MonitoringDeliverables.PaymentInstructionAudit", "AllocationEndDate", c => c.DateTime(nullable: false, precision: 7, storeType: "datetime2"));
            DropColumn("MonitoringDeliverables.PaymentInstructionAudit", "CreatedDate");
        }
    }
}
