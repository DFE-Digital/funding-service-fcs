namespace Operations.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class DuplicateContractsAddColumns : DbMigration
    {
        public override void Up()
        {
            AddColumn("Operations.DuplicateContract", "NumDuplicateAllocations", c => c.Int(nullable: false));
            AddColumn("Operations.DuplicateContract", "NumDuplicateContracts", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("Operations.DuplicateContract", "NumDuplicateContracts");
            DropColumn("Operations.DuplicateContract", "NumDuplicateAllocations");
        }
    }
}
