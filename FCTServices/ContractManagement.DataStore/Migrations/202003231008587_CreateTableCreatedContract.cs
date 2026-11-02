namespace ContractManagement.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class CreateTableCreatedContract : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractManagement.CreatedContract",
                c => new
                    {
                        ContractNumber = c.String(nullable: false, maxLength: 50),
                        ContractVersionNumber = c.Int(nullable: false),
                        ContractSubVersionNumber = c.Int(nullable: false),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => new { t.ContractNumber, t.ContractVersionNumber, t.ContractSubVersionNumber });
            
        }
        
        public override void Down()
        {
            DropTable("ContractManagement.CreatedContract");
        }
    }
}
