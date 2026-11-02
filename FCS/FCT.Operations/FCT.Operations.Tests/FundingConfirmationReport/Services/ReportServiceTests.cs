namespace FCT.Operations.Tests.FundingConfirmationReport.Services
{
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.FundingConfirmationReport.Repositories;
    using Operations.FundingConfirmationReport.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;

    [TestClass]
    public class ReportServiceTests
    {
        [TestMethod, TestCategory("DataDependent")]
        public void ReportService_ShouldReturnTheRightData()
        {
            ReportService reportService = new ReportService(new FundingConfirmationReportRepository());
            using (var context = new PaymentSchedulePolicyContext())
            {
                var rows = reportService.GetReportRows(2122, new ConnectionInfo(null, context.Database.Connection))
                    .Result;
                rows.Count.Should().Be(2245);
            }
        }
    }
}
