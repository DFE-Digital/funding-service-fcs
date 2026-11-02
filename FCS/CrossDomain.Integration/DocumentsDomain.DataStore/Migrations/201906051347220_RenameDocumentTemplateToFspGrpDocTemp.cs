namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class RenameDocumentTemplateToFspGrpDocTemp : DbMigration
    {
        public override void Up()
        {
            // we first need to make sure there are zero rows in the [DocumentsDomain].[DocumentTemplate] table as
            // we are changing the key
            Sql("delete from [DocumentsDomain].[DocumentTemplate]");
            DropForeignKey("DocumentsDomain.DocumentTemplate", "FSPGroupCode", "DocumentsDomain.FSPGroup");
            DropPrimaryKey("DocumentsDomain.DocumentTemplate");
            RenameTable(name: "DocumentsDomain.DocumentTemplate", newName: "FspGroupDocumentTemplate");
            DropIndex("DocumentsDomain.FspGroupDocumentTemplate", new[] { "FSPGroupCode" });
            
            AlterColumn("DocumentsDomain.FspGroupDocumentTemplate", "ContractType", c => c.String(maxLength: 100));
            AlterColumn("DocumentsDomain.FspGroupDocumentTemplate", "FSPGroupCode", c => c.String(nullable: false, maxLength: 50));
            AddPrimaryKey("DocumentsDomain.FspGroupDocumentTemplate", new[] { "FundingTypeCode", "FundingPeriodCode", "DocumentComponentCode", "FSPGroupCode" });
            CreateIndex("DocumentsDomain.FspGroupDocumentTemplate", "FSPGroupCode");
            AddForeignKey("DocumentsDomain.FspGroupDocumentTemplate", "FSPGroupCode", "DocumentsDomain.FSPGroup", "FSPGroupCode", cascadeDelete: true);
        }
        
        public override void Down()
        {
            DropForeignKey("DocumentsDomain.FspGroupDocumentTemplate", "FSPGroupCode", "DocumentsDomain.FSPGroup");
            DropIndex("DocumentsDomain.FspGroupDocumentTemplate", new[] { "FSPGroupCode" });
            DropPrimaryKey("DocumentsDomain.FspGroupDocumentTemplate");
            AlterColumn("DocumentsDomain.FspGroupDocumentTemplate", "FSPGroupCode", c => c.String(maxLength: 50));
            AlterColumn("DocumentsDomain.FspGroupDocumentTemplate", "ContractType", c => c.String(nullable: false, maxLength: 100));
            AddPrimaryKey("DocumentsDomain.FspGroupDocumentTemplate", new[] { "FundingTypeCode", "FundingPeriodCode", "DocumentComponentCode", "ContractType" });
            CreateIndex("DocumentsDomain.FspGroupDocumentTemplate", "FSPGroupCode");
            AddForeignKey("DocumentsDomain.DocumentTemplate", "FSPGroupCode", "DocumentsDomain.FSPGroup", "FSPGroupCode");
            RenameTable(name: "DocumentsDomain.FspGroupDocumentTemplate", newName: "DocumentTemplate");
        }
    }
}
