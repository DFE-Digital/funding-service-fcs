namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class MakeContractOrgIdNonNullable : DbMigration
    {
        public override void Up()
        {
            Sql("UPDATE ContractManagement.ApprovedContract SET OrganisationId = 'Default'");
            AlterColumn("ContractManagement.ApprovedContract", "OrganisationId", c => c.String(nullable: false, maxLength: 10));
        }
        
        public override void Down()
        {
            AlterColumn("ContractManagement.ApprovedContract", "OrganisationId", c => c.String(maxLength: 10));
        }
    }
}
