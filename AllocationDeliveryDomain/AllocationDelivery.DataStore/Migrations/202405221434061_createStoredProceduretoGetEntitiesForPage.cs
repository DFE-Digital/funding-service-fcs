namespace SFA.FCT.AllocationDelivery.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateStoredProceduretoGetEntitiesForPage : DbMigration
    {
        public override void Up()
        {
            CreateStoredProcedure("dbo.sp_AllocDelDomain_GetEntitiesForPage", c => new
            {
                skip = c.Int(10),
                pageSize=c.Int(10)

            }, StoredProcedureBody);
        }
        
        public override void Down()
        {
            DropStoredProcedure("dbo.sp_AllocDelDomain_GetEntitiesForPage");
        }

        private const string StoredProcedureBody = @"SELECT 
    atomFeed.[ID] AS [ID], 
    atomFeed.[Identifier] AS [Identifier], 
    atomFeed.[AllocationDeliveryCategory] AS [AllocationDeliveryCategory], 
    atomFeed.[CreatedDate] AS [CreatedDate], 
    atomFeed.[AllocationNumber] AS [AllocationNumber], 
    atomFeed.[VersionNumber] AS [VersionNumber], 
    atomFeed.[SubVersionNumber] AS [SubVersionNumber], 
    atomFeed.[ContractNumber] AS [ContractNumber], 
    atomFeed.[SchemaVersion] AS [SchemaVersion]
    FROM [AllocationDelivery].[AllocationDeliveryEntry] AS atomFeed
    ORDER BY row_number() OVER (ORDER BY atomFeed.[ID] ASC)
    OFFSET @skip ROWS FETCH NEXT @pageSize ROWS ONLY";
    }
}
