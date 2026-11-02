namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class createStoredProceduretoGetClosedCollectionsDesc : DbMigration
    {
        public override void Up()
        {
            CreateStoredProcedure("dbo.sp_OpsWeb_GetClosedCollectionsDesc", c => new
            {
                startRow = c.Int(10),
                numRows = c.Int(0)
            }, StoredProcedureBody);
        }

        public override void Down()
        {
            DropStoredProcedure("dbo.sp_OpsWeb_GetClosedCollectionsDesc");
        }

        private const string StoredProcedureBody = @" SELECT [CollectionType]
          ,[CollectionReturnCode]
          ,[ClosedTime]
          ,[TotalRowCount]
          ,[RetrievedRowCount]
          ,[CreatedDate]
          , count(1)  OVER() as TotalRowsInTable
          FROM [MonitoringDeliverables].[ClosedCollection]
          ORDER BY row_number() OVER(ORDER BY CreatedDate DESC)
          OFFSET @startRow ROWS FETCH NEXT @numRows ROWS ONLY";
    }
}
