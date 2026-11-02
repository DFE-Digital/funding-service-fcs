namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateStoredProceduretoGetAtomFeedItems : DbMigration
    {
        public override void Up()
        {
            CreateStoredProcedure("dbo.sp_PerfMgmtDomain_GetAtomFeedItems", c => new
            {
                skip = c.Int(10),
                pageSize=c.Int(10)

            }, StoredProcedureBody);
        }
        
        public override void Down()
        {
            DropStoredProcedure("dbo.sp_PerfMgmtDomain_GetAtomFeedItems");
        }

        private const string StoredProcedureBody = @"SELECT 
                a.[Id]
                ,a.[Identifier]
                ,a.[ItemType]
                ,a.[Ukprn]
                ,a.[ClaimTypeName]
                ,a.[AllocationGroupName]
                ,a.[Period]
                ,a.[AtomFeedItemXml]
                ,a.[CreatedDate]
            FROM [PerformanceManagement].[AtomFeedItem]
            AS a
            ORDER BY row_number() OVER(ORDER BY a.[Id] ASC)
            OFFSET @skip ROWS FETCH NEXT @pageSize ROWS ONLY";
    }
}
