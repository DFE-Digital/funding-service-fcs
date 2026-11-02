namespace ContractManagement.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class ChangeRegionTypePrimaryKeyToNonIdentity : DbMigration
    {
        public override void Up()
        {
            DropTable("ContractManagement.RegionType");
            CreateTable(
                "ContractManagement.RegionType",
                c => new
                {
                    RegionTypeCode = c.Int(nullable: false),
                    RegionTypeName = c.String(nullable: false, maxLength: 50),
                    CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => t.RegionTypeCode);
        }

        public override void Down()
        {
            DropTable("ContractManagement.RegionType");
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
    }
}
