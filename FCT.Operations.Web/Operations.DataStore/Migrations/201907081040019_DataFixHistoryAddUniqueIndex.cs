namespace Operations.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class DataFixHistoryAddUniqueIndex : DbMigration
    {
        public override void Up()
        {
            CreateIndex("Operations.DataFixHistory", new[] { "Release", "StoryNumber", "Name" }, unique: true, name: "IX_DataFixHistory_ReleaseStoryNumberName");
        }
        
        public override void Down()
        {
            DropIndex("Operations.DataFixHistory", "IX_DataFixHistory_ReleaseStoryNumberName");
        }
    }
}
