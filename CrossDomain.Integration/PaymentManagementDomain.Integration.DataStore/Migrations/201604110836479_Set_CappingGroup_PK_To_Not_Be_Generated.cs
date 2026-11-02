namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Set_CappingGroup_PK_To_Not_Be_Generated : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("PolicyCache.PolicyDeliverable", "FundingStreamPeriodCappingGroupId", "PolicyCache.CappingGroup");
            DropIndex("PolicyCache.CappingGroup", "IX_CappingGroupIndex");
            DropPrimaryKey("PolicyCache.CappingGroup");
            AlterColumn("PolicyCache.CappingGroup", "FundingStreamPeriodCappingGroupId", c => c.Int(nullable: false));
            AddPrimaryKey("PolicyCache.CappingGroup", "FundingStreamPeriodCappingGroupId");
            CreateIndex("PolicyCache.CappingGroup", "FundingStreamPeriodCappingGroupId", unique: true, name: "IX_CappingGroupIndex");
            AddForeignKey("PolicyCache.PolicyDeliverable", "FundingStreamPeriodCappingGroupId", "PolicyCache.CappingGroup", "FundingStreamPeriodCappingGroupId");
        }
        
        public override void Down()
        {
            DropForeignKey("PolicyCache.PolicyDeliverable", "FundingStreamPeriodCappingGroupId", "PolicyCache.CappingGroup");
            DropIndex("PolicyCache.CappingGroup", "IX_CappingGroupIndex");
            DropPrimaryKey("PolicyCache.CappingGroup");
            AlterColumn("PolicyCache.CappingGroup", "FundingStreamPeriodCappingGroupId", c => c.Int(nullable: false, identity: true));
            AddPrimaryKey("PolicyCache.CappingGroup", "FundingStreamPeriodCappingGroupId");
            CreateIndex("PolicyCache.CappingGroup", "FundingStreamPeriodCappingGroupId", unique: true, name: "IX_CappingGroupIndex");
            AddForeignKey("PolicyCache.PolicyDeliverable", "FundingStreamPeriodCappingGroupId", "PolicyCache.CappingGroup", "FundingStreamPeriodCappingGroupId");
        }
    }
}
