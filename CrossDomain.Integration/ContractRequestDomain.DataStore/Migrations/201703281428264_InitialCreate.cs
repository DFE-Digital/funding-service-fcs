namespace SFA.FCT.ContractRequestDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class InitialCreate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractRequest.FundingTypeFundingPeriod",
                c => new
                    {
                        FundingTypeCode = c.String(nullable: false, maxLength: 100),
                        FundingPeriodName = c.String(nullable: false, maxLength: 100),
                        ContractingActivityCloseDate = c.DateTime(),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                    })
                .PrimaryKey(t => new { t.FundingTypeCode, t.FundingPeriodName });
            
        }
        
        public override void Down()
        {
            DropTable("ContractRequest.FundingTypeFundingPeriod");
        }
    }
}
