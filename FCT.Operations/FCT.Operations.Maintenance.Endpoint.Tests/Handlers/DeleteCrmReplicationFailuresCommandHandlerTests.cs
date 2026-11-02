namespace FCT.Operations.Maintenance.Endpoint.Tests.Handlers
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Operations.Maintenance.Endpoint.Handlers;
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using SFA.FCT.Operations.Maintenance.Endpoint.Repositories;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using NServiceBus.Testing;
    using System.Threading.Tasks;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Operations.Maintenance.Endpoint.IoC;
    using NServiceBus;
    using SFA.FCS.Worker.Common;

    [TestClass]
    public class DeleteCrmReplicationFailuresCommandHandlerTests
    {
        private static string ConnectionString => ConfigurationManager.ConnectionStrings["CrmDatabaseConnectionString"].ConnectionString;

        [TestMethod, TestCategory("UnitTest")]
        public void DeleteCrmReplicationFailuresCommandHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IFcsConfiguration>()));
            container.Register(Component.For<IHandleMessages<DeleteCrmReplicationFailuresCommand>>()
                .ImplementedBy<DeleteCrmReplicationFailuresCommandHandler>());
            using (container.BeginScope())
            {
                container.Resolve<IHandleMessages<DeleteCrmReplicationFailuresCommand>>();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task DeleteCrmReplicationFailuresCommandHandler_ShouldWork()
        {
            // arrange
            const string contractId = "69fce1c8-f12b-441c-8d60-f28d3793c56e";
            ArrangeDataToBeDeleted(contractId);

            var handler = new DeleteCrmReplicationFailuresCommandHandler(
                Mock.Of<ILogger>(), 
                new CrmReplicaRepository(new LocalConfig()),
                new CrmReplicaRowDeleteRepository(),
                new LocalConfig()); 

            var testableContext = new TestableMessageHandlerContext();

            // act
            await handler.Handle(new DeleteCrmReplicationFailuresCommand(), testableContext);

            // assert 
            Assert.AreEqual(0, GetCountOfContractsForContractId(contractId), "Contract record was not removed");
            Assert.AreEqual(0, GetCountOfAllocationsForContractId(contractId), "Allocation record(s) were not removed");
            Assert.AreEqual(0, GetCountOfDeliverablesForContractId(contractId), "Deliverable record(s) were not removed");
            Assert.AreEqual(0, GetCountOfDeliverablePeriodsForContractId(contractId), "Deliverable period record(s) were not removed");
        }

        private static void ArrangeDataToBeDeleted(string contractId)
        {
            const string allocationId = "69fce1c8-f12b-441c-8d60-f28d3793c56f";
            const string deliverableOneId = "69fce1c8-f12b-441c-8d60-f28d3793c57f";
            const string deliverableTwoId = "69fce1c8-f12b-441c-8d60-f28d3793c58f";

            const string contractNo1 = "TestContractNo1";
            const string contractVersion1 = "199";
            const string contractSubVersion1 = "188";
            const int deleteLogCrmVersionNumber1 = 1300;
            const int contractCrmVersionNumber1 = 1200;

            SetupDeleteLog(contractId, deleteLogCrmVersionNumber1);
            SetupContract(contractId, contractNo1, contractVersion1, contractSubVersion1, contractCrmVersionNumber1);
            SetupAllocation(contractId, allocationId);
            SetupDeliverable(Guid.Parse(allocationId), Guid.Parse(deliverableOneId));
            SetupDeliverable(Guid.Parse(allocationId), Guid.Parse(deliverableTwoId));
            SetupDeliverablePeriod(Guid.Parse(deliverableTwoId));
            SetupDeliverablePeriod(Guid.Parse(deliverableTwoId));
        }

        private static void SetupDeleteLog(string contractId, int deleteLogCrmVersionNumber)
        {
            var sqlRemove = $"delete from [dbo].[DeleteLog] where [EntityName] = 'sfa_contract' and [RecordId] = '{contractId}' and [VersionNumber] = {deleteLogCrmVersionNumber}";
            ExecuteSql(sqlRemove, new { contractId, deleteLogCrmVersionNumber });

            var sqlInsert =  "insert into [dbo].[DeleteLog] ([EntityName],[RecordId], [SinkDeleteTime], [VersionNumber]) " + 
                            $"values('sfa_contract', '{contractId}', GetDate(), {deleteLogCrmVersionNumber})";
            ExecuteSql(sqlInsert, new { contractId, deleteLogCrmVersionNumber });

            var sqlCountCheck = $"select count(1) from [dbo].[DeleteLog] where RecordId = '{contractId}'";
            var countCheck = ExecuteScalarSql<int>(sqlCountCheck, new { contractId });

            Assert.AreEqual(1, countCheck, $"Contract DeleteLog '{contractId}' was not created within the arrange part of the test");
        }
        
        private static void SetupContract(string contractId, string contractNo, string contractVersion, string contractSubVersion, int contractCrmVersionNumber)
        {
            var sqlRemove = $"delete from [dbo].[sfa_contract] where [Id] = '{contractId}'";
            ExecuteSql(sqlRemove, new {contractId });

            var sqlInsert = "insert into [dbo].[sfa_contract] ([Id], [sfa_number], [sfa_version], [sfa_subversion], [VersionNumber] ) " +
                           $"values('{contractId}', '{contractNo}', {contractVersion}, {contractSubVersion}, {contractCrmVersionNumber})";
            ExecuteSql(sqlInsert, new { contractId, contractNo, contractVersion, contractSubVersion, contractCrmVersionNumber });

            Assert.AreEqual(1, GetCountOfContractsForContractId(contractId), $"Contract record '{contractNo}' was not created within the arrange part of the test");
        }
        
        private static void SetupAllocation(string contractId, string allocationId)
        {
            const string sqlRemove = "delete from [dbo].[sfa_contractallocation] where Id = @allocationId";
            ExecuteSql(sqlRemove, new { allocationId });

            const string sqlInsert = "insert into [dbo].[sfa_contractallocation] ([Id], [sfa_contractId]) values (@Id, @contractId)";
            ExecuteSql(sqlInsert, new { @Id = allocationId, contractId });

            Assert.AreEqual(1, GetCountOfAllocationsForContractId(contractId), $"Allocation record '{allocationId}' was not created within the arrange part of the test");
        }

        private static void SetupDeliverable(Guid allocationId, Guid deliverableId)
        {
            const string sqlRemove = "delete from [dbo].[sfa_contractdeliverable] where [id] = @deliverableId";
            ExecuteSql(sqlRemove, new { deliverableId });

            const string sqlInsert = "insert into [dbo].[sfa_contractdeliverable] ([Id], [sfa_contractallocationId]) values (@Id, @allocationId)";
            ExecuteSql(sqlInsert, new { @Id = deliverableId, allocationId });

            var sqlCountCheck = $"select count(1) from [dbo].[sfa_contractdeliverable] where [Id] = '{deliverableId}' and [sfa_contractallocationId] = '{allocationId}'";
            var countCheck = ExecuteScalarSql<int>(sqlCountCheck, new { deliverableId, allocationId });

            Assert.AreEqual(1, countCheck, $"Deliverable record '{allocationId}' was not created within the arrange part of the test");
        }

        private static void SetupDeliverablePeriod(Guid deliverableId)
        {
            const string sqlRemove = "delete from [dbo].[sfa_contractdeliverableperiod] where [sfa_contractdeliverableId] = @deliverableId";
            ExecuteSql(sqlRemove, new { deliverableId });

            const string sqlInsert = "insert into [dbo].[sfa_contractdeliverableperiod] ([Id], [sfa_contractdeliverableId]) values (@Id, @deliverableId)";
            ExecuteSql(sqlInsert, new { @Id = Guid.NewGuid(), deliverableId });

            var sqlCountCheck = $"select count(1) from [dbo].[sfa_contractdeliverableperiod] where [sfa_contractdeliverableId] = '{deliverableId}'";
            var countCheck = ExecuteScalarSql<int>(sqlCountCheck, new { deliverableId });

            Assert.AreEqual(1, countCheck, $"Deliverable period record '{deliverableId}' was not created within the arrange part of the test");
        }

        private static int GetCountOfContractsForContractId(string contractId)
        {
            var sql = $"select count(1) from sfa_contract where id = '{contractId}'";
            return ExecuteScalarSql<int>(sql, new { contractId });
        }

        private static int GetCountOfAllocationsForContractId(string contractId)
        {
            var sql = $"select count(1) from [dbo].[sfa_contractallocation] where Id in ( select a.id from [dbo].[sfa_contractallocation] a where a.sfa_contractid = '{contractId}')";
            return ExecuteScalarSql<int>(sql, new { contractId });
        }

        private static int GetCountOfDeliverablesForContractId(string contractId)
        {
            var sql = "select count(1) from [dbo].[sfa_contractdeliverable] where Id in (" +
                      "select cd.id from [dbo].[sfa_contractdeliverable] cd, [dbo].[sfa_contractallocation] a " +
                     $"where cd.sfa_contractallocationid = a.id and a.sfa_contractid = '{contractId}')";
            return ExecuteScalarSql<int>(sql, new { contractId });
        }

        private static int GetCountOfDeliverablePeriodsForContractId(string contractId)
        {
            string sql =  "select count(1) from [dbo].[sfa_contractdeliverableperiod] where Id in (" +
                          "select cdp.id from [dbo].[sfa_contractdeliverableperiod] cdp, " +
                          "[dbo].[sfa_contractdeliverable] cd, " +
                          "[dbo].[sfa_contractallocation] a " +
                          "where cdp.[sfa_contractdeliverableid] = cd.id " +
                         $"and cd.sfa_contractallocationid = a.id and a.sfa_contractid = '{contractId}')";

            return ExecuteScalarSql<int>(sql, new { contractId });
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
