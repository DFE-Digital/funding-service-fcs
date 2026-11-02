namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class IntegrityCheckTableCheckerTypeColumnLarger : DbMigration
    {
        public override void Up()
        {
            AlterColumn("ContractManagement.IntegrityCheck", "CheckerType", c => c.String(nullable: false, maxLength: 100));
        }
        
        public override void Down()
        {
            AlterColumn("ContractManagement.IntegrityCheck", "CheckerType", c => c.String(nullable: false, maxLength: 50));
        }
    }
}
