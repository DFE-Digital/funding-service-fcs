namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class RefactorDC : DbMigration
    {
        public override void Up()
        {
            DropIndex("PolicyCache.PolicySubnominal", "IX_PolicySubnominal");
            DropPrimaryKey("PolicyCache.PolicySubnominal");
            CreateTable(
                "PolicyCache.PolicyDeliverableToSubnominals",
                c => new
                    {
                        DeliverableCode = c.Int(nullable: false),
                        FundingStreamPeriod = c.String(nullable: false, maxLength: 128),
                        SubnominalCode = c.Int(nullable: false),
                        PaymentType = c.Int(nullable: false),
                    })
                .PrimaryKey(t => new { t.DeliverableCode, t.FundingStreamPeriod, t.SubnominalCode, t.PaymentType })
                .ForeignKey("PolicyCache.PolicyDeliverable", t => new { t.DeliverableCode, t.FundingStreamPeriod }, cascadeDelete: true)
                .ForeignKey("PolicyCache.PolicySubnominal", t => new { t.SubnominalCode, t.PaymentType }, cascadeDelete: true)
                .Index(t => new { t.DeliverableCode, t.FundingStreamPeriod }, name: "IX_DeliverableIndex")
                .Index(t => new { t.SubnominalCode, t.PaymentType }, name: "IX_PolicySubnominal");
            
            // Refactor migration script
            RenameColumn("PolicyCache.PolicyDeliverable", "Payable", "IsPayable");
            RenameColumn("PolicyCache.PolicySubnominal", "PaymentSubnominal", "SubnominalCode");

            AddPrimaryKey("PolicyCache.PolicySubnominal", new[] { "SubnominalCode", "PaymentType" });
            CreateIndex("PolicyCache.PolicySubnominal", new[] { "SubnominalCode", "PaymentType" }, unique: true, name: "IX_PolicySubnominal");
            DropColumn("PolicyCache.PolicyDeliverable", "PaymentSubnominal");
            DropColumn("PolicyCache.PolicyDeliverable", "ReconcilliationSubnominal");
            DropColumn("PolicyCache.PolicyDeliverable", "CappingSubnominal");
        }
        
        public override void Down()
        {
            // Refactor migration script
            RenameColumn("PolicyCache.PolicyDeliverable", "IsPayable", "Payable");
            RenameColumn("PolicyCache.PolicySubnominal", "SubnominalCode", "PaymentSubnominal");

            AddColumn("PolicyCache.PolicyDeliverable", "CappingSubnominal", c => c.Int(nullable: false));
            AddColumn("PolicyCache.PolicyDeliverable", "ReconcilliationSubnominal", c => c.Int(nullable: false));
            AddColumn("PolicyCache.PolicyDeliverable", "PaymentSubnominal", c => c.Int(nullable: false));
            DropForeignKey("PolicyCache.PolicyDeliverableToSubnominals", new[] { "SubnominalCode", "PaymentType" }, "PolicyCache.PolicySubnominal");
            DropForeignKey("PolicyCache.PolicyDeliverableToSubnominals", new[] { "DeliverableCode", "FundingStreamPeriod" }, "PolicyCache.PolicyDeliverable");
            DropIndex("PolicyCache.PolicySubnominal", "IX_PolicySubnominal");
            DropIndex("PolicyCache.PolicyDeliverableToSubnominals", "IX_PolicySubnominal");
            DropIndex("PolicyCache.PolicyDeliverableToSubnominals", "IX_DeliverableIndex");
            DropPrimaryKey("PolicyCache.PolicySubnominal");
            DropTable("PolicyCache.PolicyDeliverableToSubnominals");
            AddPrimaryKey("PolicyCache.PolicySubnominal", new[] { "PaymentSubnominal", "PaymentType" });
            CreateIndex("PolicyCache.PolicySubnominal", new[] { "PaymentSubnominal", "PaymentType" }, unique: true, name: "IX_PolicySubnominal");
        }
    }
}
