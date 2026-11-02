namespace FCT.Operations.PaymentSummary
{
    using System.Collections.Generic;
    using Aspose.Cells;
    using FCT.Operations.PaymentSummary.Services;

    public interface IExcelGenerator
    {
      Workbook GenerateWorkbook(IReadOnlyCollection<PaymentSummaryLine> paymentSummaryLines, IReadOnlyCollection<PaymentSummaryLine> paymentSummary1619Lines, ReportingPeriod reportingPeriod, IPaymentSummaryReportService paymentSummaryReportService);
    }
}