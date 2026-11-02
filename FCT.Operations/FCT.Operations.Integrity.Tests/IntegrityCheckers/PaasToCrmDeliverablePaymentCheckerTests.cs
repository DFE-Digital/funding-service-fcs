namespace FCT.Operations.Integrity.Tests.IntegrityCheckers
{
    using ContractManagement.DataStore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging.NullObjects;
    using SFA.FCT.Operations.Integrity.IntegrityCheckers;
    using SFA.FCT.Operations.Integrity.Repositories;
    using SFA.FCT.Operations.Integrity.Services;

    [TestClass]
    public class PaasToCrmDeliverablePaymentCheckerTests
    {
        [TestMethod, TestCategory("DataDependent")]
        public void PaasToCrmDeliverablePaymentChecker_CheckValues_ShouldReturnResult()
        {
            var checker = new PaasToCrmDeliverablePaymentChecker(
                new CrmDeliverablePaymentRepository(Mock.Of<IFcsConfiguration>()),
                new LoggerNullObject(),
                new PaasDeliverablePaymentLazyRepository(new ContractManagementDbContext().Database.Connection, new LoggerNullObject()),
                new ChangeTrackerService(new IntegrityCheckChangeTrackingRepository(Mock.Of<IFcsConfiguration>()), Mock.Of<ILogger>(), Mock.Of<IFcsConfiguration>()),
                null);

            IntegrityCheckResult result = checker.CheckValues();

            Assert.IsFalse(result.FoundIssues, result.IssuesCsv);
        }
    }
}
