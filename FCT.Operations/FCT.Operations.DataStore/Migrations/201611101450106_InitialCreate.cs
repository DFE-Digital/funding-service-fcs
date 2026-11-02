namespace SFA.FCT.Operations.DataStore.Migrations
{
    using System.Data.Entity.Migrations;

    public partial class InitialCreate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "Operations.ErrorMessageAction",
                c => new
                    {
                        MessageId = c.String(nullable: false, maxLength: 50),
                        MessageType = c.String(nullable: false, maxLength: 100),
                        Description = c.String(nullable: false),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETDATE()"),
                    })
                .PrimaryKey(t => t.MessageId);
            
        }
        
        public override void Down()
        {
            DropTable("Operations.ErrorMessageAction");
        }
    }
}
