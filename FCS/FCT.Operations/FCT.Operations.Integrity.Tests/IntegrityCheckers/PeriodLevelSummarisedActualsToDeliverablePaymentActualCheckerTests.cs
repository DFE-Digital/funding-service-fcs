namespace FCT.Operations.Integrity.Tests.IntegrityCheckers
{
    using ContractManagement.DataStore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Operations.Integrity.IntegrityCheckers;
    using SFA.FCT.Operations.Integrity.Repositories;
    using SFA.FCT.Operations.Integrity.Services;

    [TestClass]
    public class PeriodLevelSummarisedActualsToDeliverablePaymentActualCheckerTests
    {
        [TestMethod, TestCategory("DataDependent")]
        public void PeriodLevelSummarisedActualsToDeliverablePaymentActualChecker_CheckValues_ShouldReturnResult()
        {
            using (var contractManagementDbContext = new ContractManagementDbContext())
            {
                var checker = new PeriodLevelSummarisedActualsToDeliverablePaymentActualChecker(
                    new MonitoringDeliverablesDbContext(),
                    new PaasDeliverablePaymentLazyRepository(contractManagementDbContext.Database.Connection, Mock.Of<ILogger>()),
                    new SummarisedActualRepository(new LocalConfig()),
                    new ClosedCollectionRepository(new LocalConfig()),
                    Mock.Of<ILogger>(),
                    new MonitoringDeliverablesRepository(contractManagementDbContext.Database.Connection));

                IntegrityCheckResult result = checker.CheckValues();

                Assert.IsFalse(result.FoundIssues, result.IssuesCsv);
            }
        }
    }
}