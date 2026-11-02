namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class DocumentTemplateTableAddCreatedDate : DbMigration
    {
        public override void Up()
        {
            AddColumn("DocumentsDomain.DocumentTemplate", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()"));
        }

        public override void Down()
        {
            DropColumn("DocumentsDomain.DocumentTemplate", "CreatedDate");
        }
    }
}
