namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class createStoredProceduretoHasCollectionBeenPulledWithinDuration : DbMigration
    {
        public override void Up()
        {
            CreateStoredProcedure("dbo.sp_Operation_HasCollectionBeenPulledWithinDuration", c => new
            {
                CollectionType = c.String(20),
                secondsToRemove = c.Double(20)

            }, StoredProcedureBody);
        }

        public override void Down()
        {
            DropStoredProcedure("dbo.sp_Operation_HasCollectionBeenPulledWithinDuration");
        }

        private const string StoredProcedureBody = @"IF EXISTS (SELECT CollectionType 
                               FROM MonitoringDeliverables.ClosedCollection 
                               WHERE CollectionType = @collectionType
		                       AND CreatedDate > DATEADD(SECOND, -@secondsToRemove, GETUTCDATE())) 
                    SELECT 1
                    ELSE 
                    SELECT 0";
    }
}
