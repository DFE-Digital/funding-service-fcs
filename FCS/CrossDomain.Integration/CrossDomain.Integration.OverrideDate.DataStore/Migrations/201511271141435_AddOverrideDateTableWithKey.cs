namespace SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddOverrideDateTableWithKey : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "OverrideDate.OverrideDateWithKey",
                c => new
                    {
                        SystemOverrideDate = c.DateTime(nullable: false),
                        BusinessValueKey = c.String(nullable: false, maxLength: 128),
                        CreatedBy = c.String(),
                        CreatedOn = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => new { t.SystemOverrideDate, t.BusinessValueKey });
            
        }
        
        public override void Down()
        {
            DropTable("OverrideDate.OverrideDateWithKey");
        }
    }
}
