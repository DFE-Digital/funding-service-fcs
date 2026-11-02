namespace FCT.Operations.Integrity.Tests.IntegrityCheckers
{
    using ContractManagement.DataStore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Operations.Integrity.IntegrityCheckers;
    using SFA.FCT.Operations.Integrity.Repositories;
    using SFA.FCT.Operations.Integrity.Services;
    using System.Configuration;
    using System.Data.SqlClient;
    using ClosedCollectionRepository = SFA.FCT.Operations.Integrity.Repositories.ClosedCollectionRepository;

    [TestClass]
    public class ReportedPaymentInstructionSummarisedActualsToDeliverablePaymentCheckerTests
    {
        [TestMethod, TestCategory("DataDependent")]
        public void ReportedPaymentInstructionSummarisedActualsToDeliverablePaymentChecker_CheckValues_ShouldReturnResult()
        {
            var replicaConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString);

            using (var contractManagementDbContext = new ContractManagementDbContext())
            {
                var checker = new ReportedPaymentInstructionSummarisedActualsToDeliverablePaymentChecker(
                    new PaasDeliverablePaymentLazyRepository(contractManagementDbContext.Database.Connection, Mock.Of<ILogger>()),
                    new ReportedPaymentEnricher(new AllocationDeliverablePeriodRepository(replicaConnection)),
                    new SummarisedActualRepository(new LocalConfig()),
                    new ClosedCollectionRepository(new LocalConfig()),
                    new PaasFundingStreamPeriodRepository(contractManagementDbContext.Database.Connection));

                IntegrityCheckResult result = checker.CheckValues();

                Assert.IsFalse(result.FoundIssues, result.IssuesCsv);
            }
        }

        [TestMethod, TestCategory("DataDependent")]
        public void ReportedPaymentInstructionSummarisedActualsToDeliverablePaymentChecker_CheckValues_WithForce_ShouldReturnResult()
        {
            var replicaConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString);

            using (var contractManagementDbContext = new ContractManagementDbContext())
            {
                var checker = new ReportedPaymentInstructionSummarisedActualsToDeliverablePaymentChecker(
                    new PaasDeliverablePaymentLazyRepository(contractManagementDbContext.Database.Connection, Mock.Of<ILogger>()),
                    new ReportedPaymentEnricher(new AllocationDeliverablePeriodRepository(replicaConnection)),
                    new SummarisedActualRepository(new LocalConfig()),
                    new ClosedCollectionRepository(new LocalConfig()),
                    new PaasFundingStreamPeriodRepository(contractManagementDbContext.Database.Connection),
                    forceCheck: true);

                IntegrityCheckResult result = checker.CheckValues();

                Assert.IsFalse(result.FoundIssues, result.IssuesCsv);
            }
        }
    }
}