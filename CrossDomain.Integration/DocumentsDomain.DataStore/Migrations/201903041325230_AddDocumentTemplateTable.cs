namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddDocumentTemplateTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "DocumentsDomain.DocumentTemplate",
                c => new
                    {
                        FundingTypeCode = c.String(nullable: false, maxLength: 100),
                        FundingPeriodCode = c.String(nullable: false, maxLength: 100),
                        DocumentComponentCode = c.String(nullable: false, maxLength: 100),
                        ContractType = c.String(nullable: false, maxLength: 100),
                        Template = c.String(maxLength: 100),
                    })
                .PrimaryKey(t => new { t.FundingTypeCode, t.FundingPeriodCode, t.DocumentComponentCode, t.ContractType });
            
        }
        
        public override void Down()
        {
            DropTable("DocumentsDomain.DocumentTemplate");
        }
    }
}
