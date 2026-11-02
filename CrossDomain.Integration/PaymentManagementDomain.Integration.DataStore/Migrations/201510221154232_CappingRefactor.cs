namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CappingRefactor : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PolicyCache.CappingGroup",
                c => new
                    {
                        CappingGroupName = c.Int(nullable: false),
                        AllowUnderDeliveryToBeReUsed = c.Boolean(nullable: false),
                        AllowOverDeliveryToBeOffset = c.Boolean(nullable: false),
                        FundingStreamPeriod = c.String(maxLength: 128),
                    })
                .PrimaryKey(t => t.CappingGroupName)
                .ForeignKey("PolicyCache.PolicyFundingStreamPeriod", t => t.FundingStreamPeriod)
                .Index(t => t.CappingGroupName, unique: true, name: "IX_CappingGroupIndex")
                .Index(t => t.FundingStreamPeriod);
            
            AddColumn("PolicyCache.PolicyDeliverable", "CappingGroupName", c => c.Int());
            AddColumn("PolicyCache.PolicyFundingStreamPeriod", "PaymentCappingLevel", c => c.Int());
            AddColumn("PolicyCache.PolicyFundingStreamPeriod", "PaymentCappingPeriod", c => c.Int());
            CreateIndex("PolicyCache.PolicyDeliverable", "CappingGroupName");
            AddForeignKey("PolicyCache.PolicyDeliverable", "CappingGroupName", "PolicyCache.CappingGroup", "CappingGroupName");
        }
        
        public override void Down()
        {
            DropForeignKey("PolicyCache.CappingGroup", "FundingStreamPeriod", "PolicyCache.PolicyFundingStreamPeriod");
            DropForeignKey("PolicyCache.PolicyDeliverable", "CappingGroupName", "PolicyCache.CappingGroup");
            DropIndex("PolicyCache.PolicyDeliverable", new[] { "CappingGroupName" });
            DropIndex("PolicyCache.CappingGroup", new[] { "FundingStreamPeriod" });
            DropIndex("PolicyCache.CappingGroup", "IX_CappingGroupIndex");
            DropColumn("PolicyCache.PolicyFundingStreamPeriod", "PaymentCappingPeriod");
            DropColumn("PolicyCache.PolicyFundingStreamPeriod", "PaymentCappingLevel");
            DropColumn("PolicyCache.PolicyDeliverable", "CappingGroupName");
            DropTable("PolicyCache.CappingGroup");
        }
    }
}
