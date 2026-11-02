namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    using System.Data.Entity.Migrations.Model;

    public partial class StoredProcAndTypeForSummarisedActuals : DbMigration
    {
        public override void Up()
        {
            const String sql = @"CREATE TYPE [dbo].[SummarisedActualTableType] AS TABLE 
                                (CollectionType nvarchar(20),
                                 CollectionReturnCode nvarchar(20),
                                 OrganisationId nvarchar(20),
                                 FundingStreamPeriodCode nvarchar(20),
                                 UopCode nvarchar(20),
                                 Period int,
                                 DeliverableCode int,
                                 ContractAllocationNumber nvarchar(20),
                                 ActualVolume int,
                                 ActualValue decimal(18,2),
                                 DataCollectionsId int)";
            Sql(sql);

           Sql(@"CREATE PROCEDURE
           MonitoringDeliverables.InsertSummarisedActuals
               @actualsTable dbo.SummarisedActualTableType READONLY
           AS
               BEGIN
                INSERT INTO [MonitoringDeliverables].[SummarisedActual] (CollectionType,
                                 CollectionReturnCode,
                                 OrganisationId,
                                 FundingStreamPeriodCode,
                                 UopCode,
                                 Period,
                                 DeliverableCode,
                                 ContractAllocationNumber,
                                 ActualVolume,
                                 ActualValue,
                                 DataCollectionsId)
                SELECT CollectionType, 
                                 CollectionReturnCode,
                                 OrganisationId,
                                 FundingStreamPeriodCode,
                                 UopCode,
                                 Period,
                                 DeliverableCode,
                                 ContractAllocationNumber,
                                 ActualVolume,
                                 ActualValue,
                                 DataCollectionsId 
                FROM @actualsTable
               END");
        }
        
        public override void Down()
        {
            Sql(@"DROP TYPE IF EXISTS [dbo].[SummarisedActualTableType]");
        }
    }
}
