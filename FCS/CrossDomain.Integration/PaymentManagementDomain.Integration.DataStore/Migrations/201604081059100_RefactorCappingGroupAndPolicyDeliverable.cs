namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class RefactorCappingGroupAndPolicyDeliverable : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("PolicyCache.PolicyDeliverable", "CappingGroupName", "PolicyCache.CappingGroup");
            DropIndex("PolicyCache.CappingGroup", "IX_CappingGroupIndex");
            DropIndex("PolicyCache.CappingGroup", new[] { "FundingStreamPeriod" });
            RenameColumn(table: "PolicyCache.PolicyDeliverable", name: "CappingGroupName", newName: "FundingStreamPeriodCappingGroupId");
            RenameIndex(table: "PolicyCache.PolicyDeliverable", name: "IX_CappingGroupName", newName: "IX_FundingStreamPeriodCappingGroupId");
            DropPrimaryKey("PolicyCache.CappingGroup");
            AddColumn("PolicyCache.CappingGroup", "FundingStreamPeriodCappingGroupId", c => c.Int(nullable: false));
            AlterColumn("PolicyCache.CappingGroup", "CappingGroupName", c => c.String(maxLength: 100));
            AddPrimaryKey("PolicyCache.CappingGroup", "FundingStreamPeriodCappingGroupId");
            CreateIndex("PolicyCache.CappingGroup", "FundingStreamPeriodCappingGroupId", unique: true, name: "IX_CappingGroupIndex");
            CreateIndex("PolicyCache.CappingGroup", new[] { "FundingStreamPeriod", "CappingGroupName" }, unique: true, name: "IX_FundingStreamPeriodCappingGroupNameIndex");
            AddForeignKey("PolicyCache.PolicyDeliverable", "FundingStreamPeriodCappingGroupId", "PolicyCache.CappingGroup", "FundingStreamPeriodCappingGroupId");
        }
        
        public override void Down()
        {
            DropForeignKey("PolicyCache.PolicyDeliverable", "FundingStreamPeriodCappingGroupId", "PolicyCache.CappingGroup");
            DropIndex("PolicyCache.CappingGroup", "IX_FundingStreamPeriodCappingGroupNameIndex");
            DropIndex("PolicyCache.CappingGroup", "IX_CappingGroupIndex");
            DropPrimaryKey("PolicyCache.CappingGroup");
            AlterColumn("PolicyCache.CappingGroup", "CappingGroupName", c => c.Int(nullable: false));
            DropColumn("PolicyCache.CappingGroup", "FundingStreamPeriodCappingGroupId");
            AddPrimaryKey("PolicyCache.CappingGroup", "CappingGroupName");
            RenameIndex(table: "PolicyCache.PolicyDeliverable", name: "IX_FundingStreamPeriodCappingGroupId", newName: "IX_CappingGroupName");
            RenameColumn(table: "PolicyCache.PolicyDeliverable", name: "FundingStreamPeriodCappingGroupId", newName: "CappingGroupName");
            CreateIndex("PolicyCache.CappingGroup", "FundingStreamPeriod");
            CreateIndex("PolicyCache.CappingGroup", "CappingGroupName", unique: true, name: "IX_CappingGroupIndex");
            AddForeignKey("PolicyCache.PolicyDeliverable", "CappingGroupName", "PolicyCache.CappingGroup", "CappingGroupName");
        }
    }
}
