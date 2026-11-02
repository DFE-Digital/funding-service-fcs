namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ContractDocumentTemplate : DbMigration
    {
        public override void Up()
        {
            DropPrimaryKey("DocumentsDomain.FspGroupDocumentTemplate");
            CreateTable(
                "DocumentsDomain.ContractDocumentTemplate",
                c => new
                    {
                        FundingTypeCode = c.String(nullable: false, maxLength: 100),
                        FundingPeriodCode = c.String(nullable: false, maxLength: 100),
                        DocumentComponentCode = c.String(nullable: false, maxLength: 100),
                        ContractType = c.String(nullable: false, maxLength: 100),
                        Template = c.String(nullable: false, maxLength: 100),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => new { t.FundingTypeCode, t.FundingPeriodCode, t.DocumentComponentCode, t.ContractType });
            
            AlterColumn("DocumentsDomain.FspGroupDocumentTemplate", "ContractType", c => c.String(nullable: false, maxLength: 100));
            AlterColumn("DocumentsDomain.FspGroupDocumentTemplate", "Template", c => c.String(nullable: false, maxLength: 100));
            AddPrimaryKey("DocumentsDomain.FspGroupDocumentTemplate", new[] { "FundingTypeCode", "FundingPeriodCode", "DocumentComponentCode", "FSPGroupCode", "ContractType" });
        }
        
        public override void Down()
        {
            DropPrimaryKey("DocumentsDomain.FspGroupDocumentTemplate");
            AlterColumn("DocumentsDomain.FspGroupDocumentTemplate", "Template", c => c.String(maxLength: 100));
            AlterColumn("DocumentsDomain.FspGroupDocumentTemplate", "ContractType", c => c.String(maxLength: 100));
            DropTable("DocumentsDomain.ContractDocumentTemplate");
            AddPrimaryKey("DocumentsDomain.FspGroupDocumentTemplate", new[] { "FundingTypeCode", "FundingPeriodCode", "DocumentComponentCode", "FSPGroupCode" });
        }
    }
}
