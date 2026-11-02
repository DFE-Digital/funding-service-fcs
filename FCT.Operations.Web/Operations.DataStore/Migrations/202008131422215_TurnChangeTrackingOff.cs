namespace Operations.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class TurnChangeTrackingOff : DbMigration
    {
        public override void Up()
        {
            Sql("ALTER TABLE [PaymentSchedule].[DeliverablePayment] DISABLE  change_tracking");

            Sql(suppressTransaction: true, sql: @"DECLARE @DBName nvarchar(50), @SQLString nvarchar(200)
            SET @DBName = db_name()
            SET @SQLString = 'ALTER DATABASE [' + @DBName + '] SET  change_tracking = OFF'
            EXEC(@SQLString)");
        }
        
        public override void Down()
        {
            Sql(suppressTransaction: true, sql: @"DECLARE @DBName nvarchar(50), @SQLString nvarchar(200)
            SET @DBName = db_name()
            SET @SQLString = 'ALTER DATABASE [' + @DBName + '] SET  change_tracking = ON (change_retention = 45 days, AUTO_CLEANUP = ON)'
            EXEC(@SQLString)");

            Sql("ALTER TABLE [PaymentSchedule].[DeliverablePayment] ENABLE change_tracking WITH (track_columns_updated = OFF)");
        }
    }
}
