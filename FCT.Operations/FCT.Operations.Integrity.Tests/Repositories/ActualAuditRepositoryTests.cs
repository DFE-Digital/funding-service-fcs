namespace FCT.Operations.Integrity.Tests.Repositories
{
    using System.Configuration;
    using System.Data.SqlClient;
    using FluentAssertions;
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Operations.Integrity.Repositories;

    [TestClass]
    public class ActualAuditRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ActualAuditRepository_GetAllocationVersionAtCollectionReturn_ShouldGetContractVersion()
        {
            // arrange 
            const string allocationNumber = "AGE-480";
            const string collectionType = "AGE1516";
            const string collectionReturnCode = "G09";

            const int contractVersion = 6;
            ClearAllocationDeliverablePeriodActualAuditTable();
            AddAllocationVersionAtCollectionReturn(allocationNumber, collectionType, collectionReturnCode, contractVersion);

            var repository = new ActualAuditRepository(new SqlConnection(ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString));

            // act
            var assertContractVersion = repository.GetAllocationVersionAtCollectionReturn(allocationNumber, collectionType, collectionReturnCode);

            // assert
            assertContractVersion.Should().Be(contractVersion);
        }

        private void ClearAllocationDeliverablePeriodActualAuditTable()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"DELETE FROM [MonitoringDeliverables].[AllocationDeliverablePeriodActualAudit]";
                connection.Execute(sql);
            }
        }

        public void AddAllocationVersionAtCollectionReturn(string allocationNumber, string collectionType, string collectionReturnCode, int contractVersion)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString;

            const string sql = @"INSERT INTO [MonitoringDeliverables].[AllocationDeliverablePeriodActualAudit]
                                   ([OrganisationId]
                                   ,[FundingStreamPeriodCode]
                                   ,[UopCode]
                                   ,[DeliverableCode]
                                   ,[Period]
                                   ,[ContractAllocationNumber]
                                   ,[AllocationStartDate]
                                   ,[AllocationEndDate]
                                   ,[ActualVolume]
                                   ,[ActualValue]
                                   ,[CollectionReturnCode]
                                   ,[CollectionType]
                                   ,[ParentDeliverableCode]
                                   ,[CollectionReturnPeriod]
                                   ,[ContractVersion]
                                   ,[ContractSubVersion]
                                   ,[CreatedDate])
                             VALUES
                                   ('OrgId','FspCode','UopCode',1,'Pd'
                                   ,@allocationNumber
                                   ,'01-Nov-2021', '01-Nov-2021',1,1
                                   ,@collectionReturnCode
                                   ,@collectionType
                                   ,1,1
                                   ,@contractVersion
                                   ,0,'01-Nov-2021')";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql, new { allocationNumber, collectionType, collectionReturnCode, contractVersion });
            }
        }
    }
}