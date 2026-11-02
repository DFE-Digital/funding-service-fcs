namespace FCT.Operations.Tests.PaymentSummary.Repositories
{
    using System;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.PaymentSummary;
    using Operations.PaymentSummary.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;

    [TestClass]
    public class PaymentLineSummaryRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void PaymentLineSummaryRepository_ShouldGetPaymentSummaryLines()
        {
            PaymentLineSummaryRepository repository = new PaymentLineSummaryRepository();
            using (var context = new PaymentSchedulePolicyContext())
            {
                var lines = repository.GetPaymentSummaryLines(new ReportingPeriod(new DateTime(2022, 12, 03)),
                    new ConnectionInfo(null, context.Database.Connection)).Result;

                Assert.IsTrue(lines.Any());
            }
        }
    }
}
