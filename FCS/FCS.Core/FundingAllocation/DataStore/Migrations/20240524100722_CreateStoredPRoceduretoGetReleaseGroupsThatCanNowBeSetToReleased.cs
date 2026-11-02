using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FundingAllocation.DataStore.Migrations
{
    public partial class CreateStoredPRoceduretoGetReleaseGroupsThatCanNowBeSetToReleased : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            const string createTypeSql = @"
                    CREATE TYPE FundingAllocationIdsUDT AS TABLE (
	                    FundingId nvarchar(200))
                    ";

            const string createProcedureSql = @"
                    CREATE PROCEDURE FundingAllocation.GetReleaseGroupsThatCanNowBeSetToReleased	
                        @fundingAllocationIds FundingAllocationIdsUDT READONLY,
                        @schedulingStatus nvarchar(50),
                        @awaitingReleaseSubStatus nvarchar(50),
                        @releaseGroupId int,
                        @createdRelationship nvarchar(20)
                        
                    AS
                    BEGIN
	                    SELECT ReleaseGroupName, 
                                (select count(1) from [FundingAllocation].[FundingAllocation] where ReleaseGroupId = rg.ReleaseGroupId) totalInGroup,
                                (select count(1) from [FundingAllocation].[FundingAllocation] fa, [FundingAllocation].[Contract] c                     
                                 where fa.ReleaseGroupId = rg.ReleaseGroupId
                                 and fa.ContractId = c.Id
                                 and c.[RelationshipToFundingAllocation] = @createdRelationship
                                 and c.IsCreatedInCrm = 1) numWithContract,
                                (select count(1) from [FundingAllocation].[FundingAllocation] where ReleaseGroupId = rg.ReleaseGroupId
                                 and Status = @schedulingStatus
                                 and SubStatus = @awaitingReleaseSubStatus) totalQueued
                                from(
                                      select distinct rg.Id as ReleaseGroupId,
                                                      rg.[ReleaseGroupName]
                                      FROM [FundingAllocation].[ReleaseGroup] rg
                                      LEFT JOIN [FundingAllocation].[FundingAllocation] fa
                                      ON rg.Id = fa.ReleaseGroupId
                                      where
                                      (fa.FundingId in (select FundingId from @fundingAllocationIds)  OR
                                      rg.ID = @releaseGroupId)) rg
                    END
                    ";
            migrationBuilder.Sql("DROP PROCEDURE FundingAllocation.GetReleaseGroupsThatCanNowBeSetToReleased");
            migrationBuilder.Sql("DROP TYPE FundingAllocationIdsUDT");
            migrationBuilder.Sql(createTypeSql);
            migrationBuilder.Sql($"EXEC('{createProcedureSql}')");

        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            const string createTypeSql = @"
                    CREATE TYPE FundingAllocationIdsUDT AS TABLE (
	                    FundingId nvarchar(200))
                    ";

            const string createProcedureSql = @"
                    CREATE PROCEDURE FundingAllocation.GetReleaseGroupsThatCanNowBeSetToReleased	
                        @fundingAllocationIds FundingAllocationIdsUDT READONLY,
                        @schedulingStatus nvarchar(50),
                        @awaitingReleaseSubStatus nvarchar(50),
                        @createdRelationship nvarchar(20),
                        
                    AS
                    BEGIN
	                    SELECT ReleaseGroupName, 
                                (select count(1) from [FundingAllocation].[FundingAllocation] where ReleaseGroupId = rg.ReleaseGroupId) totalInGroup,
                                (select count(1) from [FundingAllocation].[FundingAllocation] fa, [FundingAllocation].[Contract] c                     
                                 where fa.ReleaseGroupId = rg.ReleaseGroupId
                                 and fa.ContractId = c.Id
                                 and c.[RelationshipToFundingAllocation] = @createdRelationship
                                 and c.IsCreatedInCrm = 1) numWithContract,
                                (select count(1) from [FundingAllocation].[FundingAllocation] where ReleaseGroupId = rg.ReleaseGroupId
                                 and Status = @schedulingStatus
                                 and SubStatus = @awaitingReleaseSubStatus) totalQueued
                                from(
                                      select distinct rg.Id as ReleaseGroupId,
                                                      rg.[ReleaseGroupName]
                                      FROM [FundingAllocation].[ReleaseGroup] rg
                                      LEFT JOIN [FundingAllocation].[FundingAllocation] fa
                                      ON rg.Id = fa.ReleaseGroupId
                                      where
                                      (fa.FundingId in (select FundingId from @fundingAllocationIds)  OR
                                      rg.ID = @releaseGroupId)) rg
                    END
                    ";
            migrationBuilder.Sql("DROP PROCEDURE FundingAllocation.GetReleaseGroupsThatCanNowBeSetToReleased");
            migrationBuilder.Sql("DROP TYPE FundingAllocationIdsUDT");
            migrationBuilder.Sql(createTypeSql);
            migrationBuilder.Sql($"EXEC('{createProcedureSql}')");

        }
    }
}
