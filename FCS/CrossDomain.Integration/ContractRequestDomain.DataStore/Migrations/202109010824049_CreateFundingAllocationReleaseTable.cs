namespace SFA.FCT.ContractRequestDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateFundingAllocationReleaseTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractRequest.FundingAllocationRelease",
                c => new
                    {
                        FundingAllocationReleaseId = c.Int(nullable: false, identity: true),
                        FundingTypeCode = c.String(nullable: false, maxLength: 100),
                        FundingPeriodName = c.String(nullable: false, maxLength: 100),
                        ReleaseStatus = c.String(nullable: false, maxLength: 100),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => t.FundingAllocationReleaseId)
                .Index(t => new { t.FundingTypeCode, t.FundingPeriodName, t.ReleaseStatus }, unique: true, name: "IX_FundingTypeCodeFundingPeriodNameReleaseStatus");
            
        }
        
        public override void Down()
        {
            DropIndex("ContractRequest.FundingAllocationRelease", "IX_FundingTypeCodeFundingPeriodNameReleaseStatus");
            DropTable("ContractRequest.FundingAllocationRelease");
        }
    }
}
