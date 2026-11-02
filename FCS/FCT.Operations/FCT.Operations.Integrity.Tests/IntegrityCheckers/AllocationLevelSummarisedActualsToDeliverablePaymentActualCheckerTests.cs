namespace FCT.Operations.Integrity.Tests.IntegrityCheckers
{
    using ContractManagement.DataStore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Operations.Integrity.IntegrityCheckers;
    using SFA.FCT.Operations.Integrity.Repositories;
    using SFA.FCT.Operations.Integrity.Services;
    using System.Configuration;
    using System.Data.SqlClient;

    [TestClass]
    public class AllocationLevelSummarisedActualsToDeliverablePaymentActualCheckerTests
    {
        [TestMethod, TestCategory("DataDependent")]
        public void AllocationLevelSummarisedActualsToDeliverablePaymentActualChecker_CheckValues_ShouldReturnResult()
        {
            SqlConnection replicaConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString);

            using (var contractManagementDbContext = new ContractManagementDbContext())
            {
                var connection = contractManagementDbContext.Database.Connection;
                var checker = new AllocationLevelSummarisedActualsToDeliverablePaymentActualChecker(
                    new PaasDeliverablePaymentLazyRepository(connection, Mock.Of<ILogger>()),
                    new ActualAuditRepository(replicaConnection),
                    new SummarisedActualRepository(new LocalConfig()),
                    new ClosedCollectionRepository(new LocalConfig()),
                    Mock.Of<ILogger>(),
                    new MonitoringDeliverablesRepository(replicaConnection),
                    new PaasFundingStreamPeriodRepository(replicaConnection),
                    replicaConnection,
                    new OperationsAllocationsUnderTerminationQueryRepository(replicaConnection),
                    new PaasFundingStreamPeriodRepository(replicaConnection));

                IntegrityCheckResult result = checker.CheckValues();

                Assert.IsFalse(result.FoundIssues, result.IssuesCsv);
            }
        }
    }
}