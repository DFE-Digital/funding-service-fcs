namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class MakeAllocationNumberRequired : DbMigration
    {
        public override void Up()
        {
            DropIndex("MonitoringDeliverables.PaymentInstructionAudit", "IX_PaymentInstructionAudit_ContractAllocationNumberCollectionReturnPeriod");
            DropIndex("MonitoringDeliverables.PaymentInstructionAudit", "IX_PaymentInstructionAudit_Unique");
            AlterColumn("MonitoringDeliverables.PaymentInstructionAudit", "ContractAllocationNumber", c => c.String(nullable: false, maxLength: 20));
            CreateIndex("MonitoringDeliverables.PaymentInstructionAudit", new[] { "ContractAllocationNumber", "CollectionReturnPeriod" }, name: "IX_PaymentInstructionAudit_ContractAllocationNumberCollectionReturnPeriod");
            CreateIndex("MonitoringDeliverables.PaymentInstructionAudit", new[] { "ContractAllocationNumber", "Period", "CollectionReturnPeriod", "DeliverableCode", "FundingStreamPeriodCode", "OrganisationId" }, unique: true, name: "IX_PaymentInstructionAudit_Unique");
        }
        
        public override void Down()
        {
            DropIndex("MonitoringDeliverables.PaymentInstructionAudit", "IX_PaymentInstructionAudit_Unique");
            DropIndex("MonitoringDeliverables.PaymentInstructionAudit", "IX_PaymentInstructionAudit_ContractAllocationNumberCollectionReturnPeriod");
            AlterColumn("MonitoringDeliverables.PaymentInstructionAudit", "ContractAllocationNumber", c => c.String(maxLength: 20));
            CreateIndex("MonitoringDeliverables.PaymentInstructionAudit", new[] { "ContractAllocationNumber", "Period", "CollectionReturnPeriod", "DeliverableCode", "FundingStreamPeriodCode", "OrganisationId" }, unique: true, name: "IX_PaymentInstructionAudit_Unique");
            CreateIndex("MonitoringDeliverables.PaymentInstructionAudit", new[] { "ContractAllocationNumber", "CollectionReturnPeriod" }, name: "IX_PaymentInstructionAudit_ContractAllocationNumberCollectionReturnPeriod");
        }
    }
}
