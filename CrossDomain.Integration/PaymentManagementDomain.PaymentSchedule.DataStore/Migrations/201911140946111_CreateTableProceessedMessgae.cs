namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateTableProceessedMessgae : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PaymentSchedule.ProcessedMessage",
                c => new
                    {
                        MessageId = c.String(nullable: false, maxLength: 36),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()"),
                })
                .PrimaryKey(t => t.MessageId);
            
        }
        
        public override void Down()
        {
            DropTable("PaymentSchedule.ProcessedMessage");
        }
    }
}
