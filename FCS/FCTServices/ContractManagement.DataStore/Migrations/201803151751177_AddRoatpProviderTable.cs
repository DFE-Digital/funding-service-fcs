namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddRoatpProviderTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractManagement.RoatpProvider",
                c => new
                    {
                        Ukprn = c.String(nullable: false, maxLength: 10),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                    })
                    .PrimaryKey(t => t.Ukprn);
            
        }
        
        public override void Down()
        {
            DropTable("ContractManagement.RoatpProvider");
        }
    }
}
