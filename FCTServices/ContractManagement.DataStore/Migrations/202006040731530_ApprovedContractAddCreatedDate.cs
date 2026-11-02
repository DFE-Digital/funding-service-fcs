namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ApprovedContractAddCreatedDate : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.ApprovedContract", "CreatedDate", 
                c => c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()"));
        }

        public override void Down()
        {
            DropColumn("ContractManagement.ApprovedContract", "CreatedDate");
        }
    }
}
