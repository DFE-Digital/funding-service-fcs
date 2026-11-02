namespace FCT.Operations.Integrity.Tests.IntegrityCheckers
{
    using System.Configuration;
    using System.Data.SqlClient;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.Operations.Integrity.IntegrityCheckers;
    using SFA.FCT.Operations.Integrity.Repositories;
    using SFA.FCT.Operations.Integrity.Services;

    [TestClass]
    public class PaasToCrmSubnominalAggregationCheckerTests
    {
        [TestMethod, TestCategory("DataDependent")]
        public void PaasToCrmSubnominalAggregationChecker_CheckValues_ShouldReturnResult()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;
            PaasToCrmSubnominalAggregationChecker checker =
                new PaasToCrmSubnominalAggregationChecker(
                    new PaasSubnominalAggregationRepository(new SqlConnection(connectionString)),
                    new PaasFundingStreamPeriodRepository(new SqlConnection(connectionString)), Mock.Of<IFcsConfiguration>());

            IntegrityCheckResult result = checker.CheckValues();

            Assert.IsFalse(result.FoundIssues, result.IssuesCsv);
        }
    }
}
