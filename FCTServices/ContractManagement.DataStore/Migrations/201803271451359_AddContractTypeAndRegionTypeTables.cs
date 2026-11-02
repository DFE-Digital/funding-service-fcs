namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddContractTypeAndRegionTypeTables : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractManagement.ContractType",
                c => new
                    {
                        ContractTypeName = c.String(nullable: false, maxLength: 100),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => t.ContractTypeName);
            
            CreateTable(
                "ContractManagement.RegionType",
                c => new
                    {
                        RegionTypeCode = c.Int(nullable: false, identity: true),
                        RegionTypeName = c.String(nullable: false, maxLength: 50),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => t.RegionTypeCode);
            
        }
        
        public override void Down()
        {
            DropTable("ContractManagement.RegionType");
            DropTable("ContractManagement.ContractType");
        }
    }
}
