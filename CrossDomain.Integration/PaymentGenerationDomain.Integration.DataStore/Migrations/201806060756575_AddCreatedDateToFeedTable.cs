namespace PaymentGenerationDomain.Integration.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AddCreatedDateToFeedTable : DbMigration
    {
        // This is empty because the table already has the column I want, the model didn't.
        // After this has ran the 'Model' in the migration_history table will be up to date
        public override void Up()
        { 
        }
        
        public override void Down()
        {
        }
    }
}
