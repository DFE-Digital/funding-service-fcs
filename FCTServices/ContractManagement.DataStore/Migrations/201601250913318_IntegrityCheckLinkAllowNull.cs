namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class IntegrityCheckLinkAllowNull : DbMigration
    {
        public override void Up()
        {
            AlterColumn("ContractManagement.IntegrityCheck", "Link", l => l.String(nullable: true, maxLength:250));
        }
        
        public override void Down()
        {
            AlterColumn("ContractManagement.IntegrityCheck", "Link", l => l.String(nullable: false, maxLength: 250));
        }
    }
}
