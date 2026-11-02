namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddRelationshipBetweenCdaExtractAndCdaReportFundingStreamPeriod : DbMigration
    {
        public override void Up()
        {
            CreateIndex("ContractManagement.CdaReportFundingStreamPeriod", "ExtractName");
            AddForeignKey("ContractManagement.CdaReportFundingStreamPeriod", "ExtractName", "ContractManagement.CdaExtract", "ExtractName", cascadeDelete: true);
        }
        
        public override void Down()
        {
            DropForeignKey("ContractManagement.CdaReportFundingStreamPeriod", "ExtractName", "ContractManagement.CdaExtract");
            DropIndex("ContractManagement.CdaReportFundingStreamPeriod", new[] { "ExtractName" });
        }
    }
}
