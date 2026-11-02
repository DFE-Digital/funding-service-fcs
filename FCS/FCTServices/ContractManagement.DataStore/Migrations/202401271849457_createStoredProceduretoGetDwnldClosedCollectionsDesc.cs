namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class createStoredProceduretoGetDwnldClosedCollectionsDesc : DbMigration
    {
        public override void Up()
        {
            CreateStoredProcedure("dbo.sp_OpsWeb_GetDwnldClosedCollectionsDesc", StoredProcedureBody);
        }

        public override void Down()
        {
            DropStoredProcedure("dbo.sp_OpsWeb_GetDwnldClosedCollectionsDesc");
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
          OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY";
    }
}
