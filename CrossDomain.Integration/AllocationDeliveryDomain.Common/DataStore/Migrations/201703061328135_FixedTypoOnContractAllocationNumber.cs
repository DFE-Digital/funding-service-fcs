namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FixedTypoOnContractAllocationNumber : DbMigration
    {
        public override void Up()
        {
            DropIndex("MonitoringDeliverables.PaymentInstructionAudit", "IX_PaymentInstructionAudit_ContractAllocationNumberCollectionReturnPeriod");
            DropIndex("MonitoringDeliverables.PaymentInstructionAudit", "IX_PaymentInstructionAudit_Unique");
            AddColumn("MonitoringDeliverables.PaymentInstructionAudit", "ContractAllocationNumber", c => c.String(maxLength: 20));
            CreateIndex("MonitoringDeliverables.PaymentInstructionAudit", new[] { "ContractAllocationNumber", "CollectionReturnPeriod" }, name: "IX_PaymentInstructionAudit_ContractAllocationNumberCollectionReturnPeriod");
            CreateIndex("MonitoringDeliverables.PaymentInstructionAudit", new[] { "ContractAllocationNumber", "Period", "CollectionReturnPeriod", "DeliverableCode", "FundingStreamPeriodCode", "OrganisationId" }, unique: true, name: "IX_PaymentInstructionAudit_Unique");
            DropColumn("MonitoringDeliverables.PaymentInstructionAudit", "ContractAlocationNumber");
        }
        
        public override void Down()
        {
            AddColumn("MonitoringDeliverables.PaymentInstructionAudit", "ContractAlocationNumber", c => c.String(maxLength: 20));
            DropIndex("MonitoringDeliverables.PaymentInstructionAudit", "IX_PaymentInstructionAudit_Unique");
            DropIndex("MonitoringDeliverables.PaymentInstructionAudit", "IX_PaymentInstructionAudit_ContractAllocationNumberCollectionReturnPeriod");
            DropColumn("MonitoringDeliverables.PaymentInstructionAudit", "ContractAllocationNumber");
            CreateIndex("MonitoringDeliverables.PaymentInstructionAudit", new[] { "ContractAlocationNumber", "Period", "CollectionReturnPeriod", "DeliverableCode", "FundingStreamPeriodCode", "OrganisationId" }, unique: true, name: "IX_PaymentInstructionAudit_Unique");
            CreateIndex("MonitoringDeliverables.PaymentInstructionAudit", new[] { "ContractAlocationNumber", "CollectionReturnPeriod" }, name: "IX_PaymentInstructionAudit_ContractAllocationNumberCollectionReturnPeriod");
        }
    }
}
