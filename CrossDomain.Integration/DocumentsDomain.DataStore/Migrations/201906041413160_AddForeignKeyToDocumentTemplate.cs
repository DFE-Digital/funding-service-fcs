namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddForeignKeyToDocumentTemplate : DbMigration
    {
        public override void Up()
        {
            AddColumn("DocumentsDomain.DocumentTemplate", "FSPGroupCode", c => c.String(maxLength: 50));
            CreateIndex("DocumentsDomain.DocumentTemplate", "FSPGroupCode");
            AddForeignKey("DocumentsDomain.DocumentTemplate", "FSPGroupCode", "DocumentsDomain.FSPGroup", "FSPGroupCode");
        }
        
        public override void Down()
        {
            DropForeignKey("DocumentsDomain.DocumentTemplate", "FSPGroupCode", "DocumentsDomain.FSPGroup");
            DropIndex("DocumentsDomain.DocumentTemplate", new[] { "FSPGroupCode" });
            DropColumn("DocumentsDomain.DocumentTemplate", "FSPGroupCode");
        }
    }
}
