namespace FCT.Operations.Integrity.Tests.IntegrityCheckers
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Data.SqlClient;
    using ContractManagement.DataStore;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Operations.Integrity.IntegrityCheckers;
    using SFA.FCT.Operations.Integrity.Repositories;
    using SFA.FCT.Operations.Integrity.Services;

    [TestClass]
    public class DeliverablePaymentPositiveCapCheckerTests
    {
        private const string ConnectionString = "";

        [TestMethod, TestCategory("DataDependent")]
        public void DeliverablePaymentPositiveCapChecker_CheckValues_ShouldReturnResult()
        {
            // Arrange
            using (var dbConnection = new SqlConnection(ConnectionString))
            using (var contractManagementDbContext = new ContractManagementDbContext(dbConnection))
            {
                DeliverablePaymentPositiveCapChecker checker = new DeliverablePaymentPositiveCapChecker(new PaasDeliverablePaymentLazyRepository(contractManagementDbContext.Database.Connection, Mock.Of<ILogger>()));

                // Act
                IntegrityCheckResult result = checker.CheckValues();

                // Assert
                Assert.IsFalse(result.FoundIssues, result.IssuesCsv);
            }
        }
    }
}
