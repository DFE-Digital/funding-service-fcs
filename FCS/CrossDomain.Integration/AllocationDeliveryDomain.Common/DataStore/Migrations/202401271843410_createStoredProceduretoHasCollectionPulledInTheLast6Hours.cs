namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class createStoredProceduretoHasCollectionPulledInTheLast6Hours : DbMigration
    {
        public override void Up()
        {
            CreateStoredProcedure("dbo.sp_Operation_HasCollectionPulledInTheLast6Hours", c => new
            {
                CollectionType = c.String(20)

            }, StoredProcedureBody);
        }

        public override void Down()
        {
            DropStoredProcedure("dbo.sp_Operation_HasCollectionPulledInTheLast6Hours");
        }

        private const string StoredProcedureBody = @"IF EXISTS (SELECT CollectionType 
                               FROM MonitoringDeliverables.ClosedCollection 
                               WHERE CollectionType = @collectionType
		                       AND CreatedDate > GETUTCDATE() - (6/24.0)) -- 6 hours sgo
                    SELECT 1
                    ELSE 
                    SELECT 0";
    }
}
