namespace FCT.Operations.PaymentSummary.Extensions
{
    public static class ReportingPeriodExtensions
    {
        public static string ToPaymentSummaryReportFilename(this ReportingPeriod reportingPeriod)
        {
            string paymentAll, paymentProfile, filename;

            paymentAll = $"{reportingPeriod.Year}-{reportingPeriod.Month:D2} Payments.xlsx";

            paymentProfile = $"{reportingPeriod.Year}-{reportingPeriod.Month:D2} Grant funding.xlsx";

            filename = reportingPeriod.Day < 7 ? paymentProfile : paymentAll;

            return filename;
        }

        public static string ToPaymentSummaryReportWorkbookTitle(this ReportingPeriod reportingPeriod)
        {
            return $"FCS Consolidated Payment Summary Report - {reportingPeriod.Period}";
        }
    }
}
