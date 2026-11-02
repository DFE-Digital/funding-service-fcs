namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FspTableCreate : DbMigration
    {
        public override void Up()
        {
            Sql("Delete from [ContractManagement].[FundingStreamPeriodLegalDeliverable]");
            CreateTable(
                "ContractManagement.FundingStreamPeriod",
                c => new
                    {
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 100),
                        StartDate = c.DateTime(nullable: false),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => t.FundingStreamPeriodCode);
            
            CreateIndex("ContractManagement.FundingStreamPeriodLegalDeliverable", "FundingStreamPeriodCode");
            AddForeignKey("ContractManagement.FundingStreamPeriodLegalDeliverable", "FundingStreamPeriodCode", "ContractManagement.FundingStreamPeriod", "FundingStreamPeriodCode", cascadeDelete: true);
        }
        
        public override void Down()
        {
            DropForeignKey("ContractManagement.FundingStreamPeriodLegalDeliverable", "FundingStreamPeriodCode", "ContractManagement.FundingStreamPeriod");
            DropIndex("ContractManagement.FundingStreamPeriodLegalDeliverable", new[] { "FundingStreamPeriodCode" });
            DropTable("ContractManagement.FundingStreamPeriod");
        }
    }
}
