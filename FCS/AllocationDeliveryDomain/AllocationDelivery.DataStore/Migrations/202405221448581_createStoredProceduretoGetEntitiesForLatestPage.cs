namespace SFA.FCT.AllocationDelivery.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateStoredProceduretoGetEntitiesForLatestPage : DbMigration
    {
        public override void Up()
        {
            CreateStoredProcedure("dbo.sp_AllocDelDomain_GetEntitiesForLatestPage", c => new
            {
                rowsInLatestPage = c.Int(10)

            }, StoredProcedureBody);
        }
        
        public override void Down()
        {
            DropStoredProcedure("dbo.sp_AllocDelDomain_GetEntitiesForLatestPage");
        }

        private const string StoredProcedureBody = @"SELECT TOP (@rowsInLatestPage) 
    [Extent1].[ID] AS [ID], 
    [Extent1].[Identifier] AS [Identifier], 
    [Extent1].[AllocationDeliveryCategory] AS [AllocationDeliveryCategory], 
    [Extent1].[CreatedDate] AS [CreatedDate], 
    [Extent1].[AllocationNumber] AS [AllocationNumber], 
    [Extent1].[VersionNumber] AS [VersionNumber], 
    [Extent1].[SubVersionNumber] AS [SubVersionNumber], 
    [Extent1].[ContractNumber] AS [ContractNumber], 
    [Extent1].[SchemaVersion] AS [SchemaVersion]
    FROM [AllocationDelivery].[AllocationDeliveryEntry] AS [Extent1]
    ORDER BY [Extent1].[ID] DESC";
    }
}
