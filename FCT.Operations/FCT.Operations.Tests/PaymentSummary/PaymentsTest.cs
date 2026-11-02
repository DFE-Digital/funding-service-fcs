using System;
using System.Configuration;
using FCT.Operations.PaymentSummary;
using FCT.Operations.PaymentSummary.Repositories;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.CrossDomain.Integration.Entities.Data;
using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;

namespace FCT.Operations.Tests.PaymentSummary
{
    using Operations.PaymentSummary.Services;

    [TestClass]
    public class PaymentsTest
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void Payments_ShouldCreateGoodSpreadsheet()
        {

            const string ConnnectionStringOAT =
                                "";
            const string ConnnectionStringLive =
                "";

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.Database.Connection.ConnectionString = ConnnectionStringOAT;

                PaymentLineSummaryRepository repository = new PaymentLineSummaryRepository();
                var reportingPeriod = new ReportingPeriod(new DateTime(2023, 07, 10));

                var lines = repository.GetPaymentSummaryLines(reportingPeriod,
                    new ConnectionInfo(null, context.Database.Connection)).Result;
                var lines1619 = repository.Get1619PaymentSummaryLines(reportingPeriod,
                   new ConnectionInfo(null, context.Database.Connection)).Result;

                //-**********-Removed as part spliting DFE/ESFA-*****************-//
                //PaymentSummaryReportService service = new PaymentSummaryReportService(null, null);
                //var filteredLines = service.FilterOutUnnecessaryLines(lines);
                //var workbook = excelGenerator.GenerateWorkbook(filteredLines, reportingPeriod);
                //var filteredLines = service.FilterOutUnnecessaryLines(lines);
                //-**********-END-*****************-//
                ExcelGenerator excelGenerator = new ExcelGenerator();
                PaymentSummaryReportService service = new PaymentSummaryReportService(null, null);               
                var workbook = excelGenerator.GenerateWorkbook(lines, lines1619, reportingPeriod, service);

                workbook.Save(@"Tests.xlsx");
            }
        }
    }
}
