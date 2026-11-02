namespace FCT.Operations.Integrity.Tests.Services
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using ContractManagement.DataStore;
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging.NullObjects;
    using SFA.FCT.Operations.Integrity.IntegrityCheckers;
    using SFA.FCT.Operations.Integrity.Repositories;
    using SFA.FCT.Operations.Integrity.Services;
    using SFA.FCT.Operations.Integrity.Storage;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Cache;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using ClosedCollectionRepository = SFA.FCT.Operations.Integrity.Repositories.ClosedCollectionRepository;

    [TestClass]
    public class IntegrityCheckerRunnerTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void IntegrityCheckerRunner_ShouldWriteToChangeTrackingStorageWhenChangeTrackingInfoReturnedByChecker()
        {
            const string integrityCheckerName = "TEST_INTEGRITY_CHECKER_WITH_CHANGE_TRACKING";
            const long originalCurrentVersion = 100;
            const long latestCurrentVersion = 200;

            // arrange
            using (var connection =
                new SqlConnection(ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString))
            {
                connection.Execute("DELETE FROM Operations.IntegrityCheckChangeTracking WHERE Name = @name",
                    new {name = integrityCheckerName});
                connection.Execute(
                    "INSERT INTO Operations.IntegrityCheckChangeTracking (Name, CurrentVersion) VALUES (@name, @currentVersion)",
                    new {name = integrityCheckerName, currentVersion = originalCurrentVersion});
            }

            Mock<IIntegrityChecker> integrityCheckerMock = new Mock<IIntegrityChecker>();
            integrityCheckerMock
                .Setup(m => m.CheckValues())
                .Returns(new IntegrityCheckResult(false, null, latestCurrentVersion));

            IntegrityCheckerRunner runner = new IntegrityCheckerRunner(
                integrityCheckerMock.Object,
                Mock.Of<ICheckerDocumentStoreWriter>(),
                null,
                Mock.Of<ILogger>(),
                new IntegrityCheckChangeTrackingRepository(new LocalConfig()), new LocalConfig());

            // act
            runner.Run(integrityCheckerName, DateTime.UtcNow);

            // assert
            using (var connection =
                new SqlConnection(ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString))
            {
                long storedCurrentVersion = connection.ExecuteScalar<long>(
                    "SELECT CurrentVersion FROM Operations.IntegrityCheckChangeTracking WHERE Name = @name",
                    new {name = integrityCheckerName});

                Assert.AreEqual(latestCurrentVersion, storedCurrentVersion, "CurrentVersion was not updated correctly");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void
            IntegrityCheckerRunner_ShouldNotWriteToChangeTrackingStorageWhenChangeTrackingInfoNotReturnedByChecker()
        {
            const string integrityCheckerName = "TEST_INTEGRITY_CHECKER_WITHOUT_CHANGE_TRACKING";

            // arrange
            using (var connection =
                new SqlConnection(ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString))
            {
                connection.Execute("DELETE FROM Operations.IntegrityCheckChangeTracking WHERE Name = @name",
                    new {name = integrityCheckerName});
            }

            Mock<IIntegrityChecker> integrityCheckerMock = new Mock<IIntegrityChecker>();
            integrityCheckerMock
                .Setup(m => m.CheckValues())
                .Returns(new IntegrityCheckResult(false, null));

            IntegrityCheckerRunner runner = new IntegrityCheckerRunner(
                integrityCheckerMock.Object,
                Mock.Of<ICheckerDocumentStoreWriter>(),
                null,
                Mock.Of<ILogger>(),
                new IntegrityCheckChangeTrackingRepository(new LocalConfig()), new LocalConfig());

            // act
            runner.Run(integrityCheckerName, DateTime.UtcNow);

            // assert
            using (var connection =
                new SqlConnection(ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString))
            {
                int matchingChangeTrackingRowCount = connection.ExecuteScalar<int>(
                    "SELECT COUNT(*) FROM Operations.IntegrityCheckChangeTracking WHERE Name = @name",
                    new {name = integrityCheckerName});

                Assert.AreEqual(0, matchingChangeTrackingRowCount, "Change tracking storage was updated unexpectedly");
            }
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void IntegrityCheckerRunner_ShouldRunPAASToCrmDeliverablePaymentChecker()
        {
            PaasToCrmDeliverablePaymentChecker checker = new PaasToCrmDeliverablePaymentChecker(
                new CrmDeliverablePaymentRepository(new LocalConfig()),
                new LoggerNullObject(),
                new PaasDeliverablePaymentLazyRepository(new ContractManagementDbContext().Database.Connection,
                    new LoggerNullObject()),
                new ChangeTrackerService(new IntegrityCheckChangeTrackingRepository(new LocalConfig()),
                    Mock.Of<ILogger>(), new LocalConfig()),
                null);
            IntegrityCheckerRunner runner = new IntegrityCheckerRunner(checker,
                new AzureDocumentStoreWriter(new LocalConfig()), null, Mock.Of<ILogger>(),
                new IntegrityCheckChangeTrackingRepository(new LocalConfig()), new LocalConfig());
            runner.Run("TestPAASToCrmDeliverablePay", DateTime.Now);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void
            IntegrityCheckerRunner_ShouldRunReportedPaymentInstructionSummarisedActualsToDeliverablePaymentChecker()
        {
            var replicaConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString);

            using (var contractManagementDbContext = new ContractManagementDbContext())
            {
                var checker = new ReportedPaymentInstructionSummarisedActualsToDeliverablePaymentChecker(
                    new PaasDeliverablePaymentLazyRepository(contractManagementDbContext.Database.Connection,
                        Mock.Of<ILogger>()),
                    new ReportedPaymentEnricher(new AllocationDeliverablePeriodRepository(replicaConnection)),
                    new SummarisedActualRepository(new LocalConfig()),
                    new ClosedCollectionRepository(new LocalConfig()),
                    new PaasFundingStreamPeriodRepository(contractManagementDbContext.Database.Connection));

                IntegrityCheckerRunner runner = new IntegrityCheckerRunner(checker,
                    new AzureDocumentStoreWriter(new LocalConfig()),
                    null, Mock.Of<ILogger>(), new IntegrityCheckChangeTrackingRepository(new LocalConfig()),
                    new LocalConfig());

                runner.Run("TestRepPayInstSumdActToDelPay", DateTime.Now);
            }
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void IntegrityCheckerRunner_ShouldRunPeriodLevelSummarisedActualsToDeliverablePaymentActualChecker()
        {
            using (var contractManagementDbContext = new ContractManagementDbContext())
            {
                var checker = new PeriodLevelSummarisedActualsToDeliverablePaymentActualChecker(
                    new MonitoringDeliverablesDbContext(),
                    new PaasDeliverablePaymentLazyRepository(contractManagementDbContext.Database.Connection,
                        Mock.Of<ILogger>()),
                    new SummarisedActualRepository(new LocalConfig()),
                    new ClosedCollectionRepository(new LocalConfig()),
                    Mock.Of<ILogger>(),
                    new MonitoringDeliverablesRepository(contractManagementDbContext.Database.Connection));

                IntegrityCheckerRunner runner = new IntegrityCheckerRunner(checker,
                    new AzureDocumentStoreWriter(new LocalConfig()),
                    null, Mock.Of<ILogger>(), new IntegrityCheckChangeTrackingRepository(new LocalConfig()),
                    new LocalConfig());

                runner.Run("TestPeriodLevelSumActToDelPay", DateTime.Now);
            }
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void IntegrityCheckerRunner_ShouldRunAllocationLevelSummarisedActualsToDeliverablePaymentActualChecker()
        {
            SqlConnection replicaConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString);
            
            using (var contractManagementDbContext = new ContractManagementDbContext())
            {
                var checker = new AllocationLevelSummarisedActualsToDeliverablePaymentActualChecker(
                    new PaasDeliverablePaymentLazyRepository(contractManagementDbContext.Database.Connection, Mock.Of<ILogger>()),
                    new ActualAuditRepository(replicaConnection),
                    new SummarisedActualRepository(new LocalConfig()),
                    new ClosedCollectionRepository(new LocalConfig()),
                    Mock.Of<ILogger>(),
                    new MonitoringDeliverablesRepository(replicaConnection),
                    new PaasFundingStreamPeriodRepository(replicaConnection),
                    replicaConnection,
                    new OperationsAllocationsUnderTerminationQueryRepository(replicaConnection),
                    new PaasFundingStreamPeriodRepository(replicaConnection));

                IntegrityCheckerRunner runner = new IntegrityCheckerRunner(checker,
                    new AzureDocumentStoreWriter(new LocalConfig()),
                    null, Mock.Of<ILogger>(), new IntegrityCheckChangeTrackingRepository(new LocalConfig()),
                    new LocalConfig());

                runner.Run("TestAllocSumActToDelPay", DateTime.Now);
            }
        }
    }
}
