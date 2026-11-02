namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ArchivedDocumentTableRemoveColumnAmendmentType : DbMigration
    {
        public override void Up()
        {
            DropColumn("DocumentsDomain.ArchivedDocument", "AmendmentType");
        }
        
        public override void Down()
        {
            AddColumn("DocumentsDomain.ArchivedDocument", "AmendmentType", c => c.Int(nullable: false));
        }
    }
}
