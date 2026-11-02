namespace FCT.Operations.Maintenance.Endpoint.Tests.Repositories
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Operations.Maintenance.Endpoint.Repositories;

    [TestClass]
    public class CrmReplicaRowDeleteRepositoryTests
    {
        private static string ConnectionString => ConfigurationManager.ConnectionStrings["CrmDatabaseConnectionString"].ConnectionString;

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmReplicaRowDeleteRepository_DeleteContactForContractId_ShouldDeleteContractForContractId()
        {
            // arrange
            const string contractId = "69fce1c8-f12b-441c-8d60-f28d3793c56e";
            const string sqlCountCheck = @"select count(1) from [dbo].[sfa_contract] 
                                           where Id = @contractId";

            DeleteContract(contractId);
            CreateContract(contractId);

            var assertContractCount = ExecuteScalarSql<int>(sqlCountCheck, new { contractId });
            Assert.AreEqual(1, assertContractCount, "Contract record was not created within the arrange part of the test");

            using (var connection = new SqlConnection(ConnectionString))
            {
                connection.Open();
                var transaction = connection.BeginTransaction();
                var connectionInfo = new ConnectionInfo(transaction, connection);

                var repository = new CrmReplicaRowDeleteRepository();

                // act
                repository.DeleteContactForContractId(Guid.Parse(contractId), connectionInfo).Wait();

                transaction.Commit();
            }

            // assert
            assertContractCount = ExecuteScalarSql<int>(sqlCountCheck, new { contractId });
            Assert.AreEqual(0, assertContractCount, "Contract record was not removed");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmReplicaRowDeleteRepository_DeleteContactForContractId_ShouldDeleteContractAllocationForContractId()
        {
            // arrange
            const string contractId = "69fce1c8-f12b-441c-8d60-f28d3793c56e";
            const string allocationId1 = "69fce1c8-f12b-441c-8d60-f28d3793c56f";
            const string allocationId2 = "5eeae65e-63ca-4ad6-a878-9cf2bd95a013";
            const string sqlCountCheck = @"select count(1) from [dbo].[sfa_contractallocation] 
                                           where Id in (
                                           select a.id from 
                                           [dbo].[sfa_contractallocation] a
                                           where a.sfa_contractid = @contractId)";
            DeleteContract(contractId);
            DeleteAllocation(contractId);

            CreateContract(contractId);
            CreateAllocation(contractId, allocationId1);
            CreateAllocation(contractId, allocationId2);

            var assertAllocationCount = ExecuteScalarSql<int>(sqlCountCheck, new { contractId });
            Assert.AreEqual(2, assertAllocationCount, "Contract allocation records were not created within the arrange part of the test");

            using (var connection = new SqlConnection(ConnectionString))
            {
                connection.Open();
                var transaction = connection.BeginTransaction();

                var connectionInfo = new ConnectionInfo(transaction, connection);
                var repository = new CrmReplicaRowDeleteRepository();

                // act
                repository.DeleteContactAllocationsForContractId(Guid.Parse(contractId), connectionInfo).Wait();

                transaction.Commit();
            }

            // assert
            assertAllocationCount = ExecuteScalarSql<int>(sqlCountCheck, new { contractId });

            Assert.AreEqual(0, assertAllocationCount, "Allocation record was not removed");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmReplicaRowDeleteRepository_DeleteContactForContractId_ShouldDeleteDeliverableForContractId()
        {
            // arrange
            const string contractId = "69fce1c8-f12b-441c-8d60-f28d3793c56e";
            const string allocationId = "69fce1c8-f12b-441c-8d60-f28d3793c56f";
            const string deliverableOneId = "69fce1c8-f12b-441c-8d60-f28d3793c57f";
            const string deliverableTwoId = "69fce1c8-f12b-441c-8d60-f28d3793c58f";
            const string sqlCountCheck = @"select count(1) from [dbo].[sfa_contractdeliverable] 
                                          where Id in (
                                          select cd.id 
                                          from [dbo].[sfa_contractdeliverable] cd,
                                          [dbo].[sfa_contractallocation] a
                                          where cd.sfa_contractallocationid = a.id
                                          and a.sfa_contractid = @contractId)";

            DeleteContract(contractId);
            DeleteAllocation(contractId);
            DeleteDeliverables(Guid.Parse(allocationId));

            CreateContract(contractId);
            CreateAllocation(contractId, allocationId);
            CreateDeliverable(Guid.Parse(allocationId), Guid.Parse(deliverableOneId));
            CreateDeliverable(Guid.Parse(allocationId), Guid.Parse(deliverableTwoId));

            var assertDeliverableCount = ExecuteScalarSql<int>(sqlCountCheck, new { contractId });
            Assert.AreEqual(2, assertDeliverableCount, "Deliverable records were not created within the arrange part of the test");

            using (var connection = new SqlConnection(ConnectionString))
            {
                connection.Open();
                var transaction = connection.BeginTransaction();

                var connectionInfo = new ConnectionInfo(transaction, connection);
                var repository = new CrmReplicaRowDeleteRepository();

                // act
                repository.DeleteContactAllocationsForContractId(Guid.Parse(contractId), connectionInfo).Wait();

                transaction.Commit();
            }

            // assert
            assertDeliverableCount = ExecuteScalarSql<int>(sqlCountCheck, new { contractId });

            Assert.AreEqual(0, assertDeliverableCount, "Deliverable records were not removed");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmReplicaRowDeleteRepository_DeleteContactForContractId_ShouldDeleteContactDeliverablePeriodsForContractId()
        {
            // arrange
            const string contractId = "69fce1c8-f12b-441c-8d60-f28d3793c56e";
            const string allocationId = "69fce1c8-f12b-441c-8d60-f28d3793c56f";
            const string deliverableOneId = "69fce1c8-f12b-441c-8d60-f28d3793c57f";
            const string deliverableTwoId = "69fce1c8-f12b-441c-8d60-f28d3793c58f";

            const string sqlCountCheck = @"select count(1) from [dbo].[sfa_contractdeliverableperiod] 
                                          where Id in (
                                          select cdp.id
                                          from [dbo].[sfa_contractdeliverableperiod] cdp, 
                                          [dbo].[sfa_contractdeliverable] cd,
                                          [dbo].[sfa_contractallocation] a
                                          where cdp.[sfa_contractdeliverableid] = cd.id
                                          and cd.sfa_contractallocationid = a.id
                                          and a.sfa_contractid = @contractId)";

            DeleteContract(contractId);
            DeleteAllocation(contractId);
            DeleteDeliverables(Guid.Parse(allocationId));
            DeleteDeliverablePeriods(deliverableOneId);
            DeleteDeliverablePeriods(deliverableTwoId);

            CreateContract(contractId);
            CreateAllocation(contractId, allocationId);
            CreateDeliverable(Guid.Parse(allocationId), Guid.Parse(deliverableOneId));
            CreateDeliverable(Guid.Parse(allocationId), Guid.Parse(deliverableTwoId));
            CreateDeliverablePeriod(Guid.Parse(deliverableOneId));
            CreateDeliverablePeriod(Guid.Parse(deliverableTwoId));

            var assertDeliverablePeriodCount = ExecuteScalarSql<int>(sqlCountCheck, new { contractId });
            Assert.AreEqual(2, assertDeliverablePeriodCount, "Deliverable period records were not created within the arrange part of the test");

            var connectionString = ConfigurationManager.ConnectionStrings["CrmDatabaseConnectionString"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();
                var transaction = connection.BeginTransaction();

                var connectionInfo = new ConnectionInfo(transaction, connection);
                var repository = new CrmReplicaRowDeleteRepository();

                // act
                repository.DeleteContactAllocationsForContractId(Guid.Parse(contractId), connectionInfo).Wait();

                transaction.Commit();
            }

            // assert
            assertDeliverablePeriodCount = ExecuteScalarSql<int>(sqlCountCheck, new { contractId });

            Assert.AreEqual(0, assertDeliverablePeriodCount, "Deliverable period records were not removed");
        }
        
        private static void DeleteContract(string contractId)
        {
            const string sql = "delete from [dbo].[sfa_contract] where Id = @contractId";

            ExecuteSql(sql, new { contractId });
        }

        private static void CreateContract(string contractId)
        {
            const string sql = "insert into [dbo].[sfa_contract] ([Id]) values (@contractId)";

            ExecuteSql(sql, new { contractId });
        }

        private static void CreateAllocation(string contractId, string allocationId)
        {
            const string sql = "insert into [dbo].[sfa_contractallocation] ([Id], [sfa_contractId]) values (@Id, @contractId)";

            ExecuteSql(sql, new { @Id = allocationId, contractId });
        }

        private static void DeleteAllocation(string contractId)
        {
            const string sql = "delete from [dbo].[sfa_contractallocation] where [sfa_contractId] = @contractId";

            ExecuteSql(sql, new { contractId });
        }

        private static void DeleteDeliverables(Guid allocationId)
        {
            const string sql = "delete from [dbo].[sfa_contractdeliverable] where [sfa_contractallocationId] = @allocationId";

            ExecuteSql(sql, new { allocationId });
        }

        private static void CreateDeliverable(Guid allocationId, Guid deliverableId)
        {
            const string sql = "insert into [dbo].[sfa_contractdeliverable] ([Id], [sfa_contractallocationId]) values (@Id, @allocationId)";

            ExecuteSql(sql, new { @Id = deliverableId, allocationId });
        }

        private static void DeleteDeliverablePeriods(string deliverableId)
        {
            const string sql = "delete from [dbo].[sfa_contractdeliverableperiod] where [sfa_contractdeliverableId] = @deliverableId";

            ExecuteSql(sql, new { deliverableId });
        }

        private static void CreateDeliverablePeriod(Guid deliverableId)
        {
            const string sql = "insert into [dbo].[sfa_contractdeliverableperiod] ([Id], [sfa_contractdeliverableId]) values (@Id, @deliverableId)";

            ExecuteSql(sql, new { @Id = Guid.NewGuid(), deliverableId });
        }

        private static void ExecuteSql(string sql, object parameter)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                connection.Execute(sql, parameter);
            }
        }

        private static T ExecuteScalarSql<T>(string sql, object parameter)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                return connection.ExecuteScalar<T>(sql, parameter);
            }
        }
    }
}
