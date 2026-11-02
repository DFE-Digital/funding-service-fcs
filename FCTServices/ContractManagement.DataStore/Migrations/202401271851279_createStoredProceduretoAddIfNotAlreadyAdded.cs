namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class createStoredProceduretoAddIfNotAlreadyAdded : DbMigration
    {
        public override void Up()
        {
            CreateStoredProcedure("dbo.sp_OpsWeb_AddIfNotAlreadyAdded", c => new
            {
                providerId = c.String(10)

            }, StoredProcedureBody);
        }

        public override void Down()
        {
            DropStoredProcedure("dbo.sp_OpsWeb_AddIfNotAlreadyAdded");
        }

        private const string StoredProcedureBody = @"DECLARE @minId INT
                                     BEGIN
                                         SELECT TOP 1 @minId = EventId FROM [ContractManagement].[EngagementEvent] ORDER BY EventId
                                         SET @minId = ISNULL(@minId, 0) - 1

                                         IF NOT EXISTS (SELECT 1 FROM [ContractManagement].[EngagementEvent] WHERE ProviderId=@providerId and CreatedDate >  DATEADD(minute, -10, getdate()))
                                          BEGIN 
                                           INSERT INTO [ContractManagement].[EngagementEvent] ([EventId]
                                           ,[EventType]
                                           ,[ProviderId]
                                           ,[ProcessingState]) values (@minId, 'INITIATED', @providerId, 0);

                                          SELECT 1 as added, @minId as eventId;
                                          END
                                         ELSE
                                           SELECT 0 as added, @minId as eventId;
                                     END";
    }
}
