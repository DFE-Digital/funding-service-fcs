namespace ContractManagement.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AddAmendmentTypeToCreatedContract : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.CreatedContract", "AmendmentType", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("ContractManagement.CreatedContract", "AmendmentType");
        }
    }
}
