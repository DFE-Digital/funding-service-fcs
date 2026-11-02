namespace FCT.Operations.Integrity.Tests.IntegrityCheckers
{
    using System.Configuration;
    using System.Data.SqlClient;
    using Microsoft.VisualStudio.TestTools.UnitTesting;   
    using SFA.FCT.Operations.Integrity.IntegrityCheckers;
    using SFA.FCT.Operations.Integrity.Repositories;
    using SFA.FCT.Operations.Integrity.Services;

    [TestClass]
    public class CrmToPaasSubnominalAggregationCheckerTests
    {
        [TestMethod, TestCategory("DataDependent")]
        public void CrmToPaasSubnominalAggregationChecker_CheckValues_ShouldReturnResult()
        {
            SubnominalAggregationChecker.ClearCache();
            string connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            CrmToPaasSubnominalAggregationChecker checker =
                new CrmToPaasSubnominalAggregationChecker(
                    new PaasSubnominalAggregationRepository(new SqlConnection(connectionString)),
                    new PaasFundingStreamPeriodRepository(new SqlConnection(connectionString)), new LocalConfig());

            IntegrityCheckResult result = checker.CheckValues();

            Assert.IsFalse(result.FoundIssues, result.IssuesCsv);
        }
    }
}
