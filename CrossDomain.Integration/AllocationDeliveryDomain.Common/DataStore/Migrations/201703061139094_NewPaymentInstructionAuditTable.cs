namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class NewPaymentInstructionAuditTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "MonitoringDeliverables.PaymentInstructionAudit",
                c => new
                    {
                        CollectionReturnPeriod = c.Int(nullable: false),
                        OrganisationId = c.String(nullable: false, maxLength: 10),
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 100),
                        DeliverableCode = c.Int(nullable: false),
                        Period = c.String(nullable: false, maxLength: 6),
                        Id = c.Int(nullable: false, identity: true),
                        ContractAlocationNumber = c.String(maxLength: 20),
                        Ukprn = c.String(maxLength: 8),
                        ContractNumber = c.String(maxLength: 20),
                        ContractVersion = c.Int(nullable: false),
                        ContractSubVersion = c.Int(nullable: false),
                        AllocationStartDate = c.DateTime(nullable: false, precision: 7, storeType: "datetime2"),
                        AllocationEndDate = c.DateTime(nullable: false, precision: 7, storeType: "datetime2"),
                        CollectionReturnCode = c.String(maxLength: 10),
                        PeriodTypeCode = c.String(maxLength: 2),
                        CollectionType = c.String(maxLength: 20),
                        PaymentValue = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ParentDeliverableCode = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.Id)
                .Index(t => new { t.ContractAlocationNumber, t.CollectionReturnPeriod }, name: "IX_PaymentInstructionAudit_ContractAllocationNumberCollectionReturnPeriod")
                .Index(t => new { t.ContractAlocationNumber, t.Period, t.CollectionReturnPeriod, t.DeliverableCode, t.FundingStreamPeriodCode, t.OrganisationId }, unique: true, name: "IX_PaymentInstructionAudit_Unique");
            
        }
        
        public override void Down()
        {
            DropIndex("MonitoringDeliverables.PaymentInstructionAudit", "IX_PaymentInstructionAudit_Unique");
            DropIndex("MonitoringDeliverables.PaymentInstructionAudit", "IX_PaymentInstructionAudit_ContractAllocationNumberCollectionReturnPeriod");
            DropTable("MonitoringDeliverables.PaymentInstructionAudit");
        }
    }
}
