namespace FCT.Operations.PaymentSummary.Services
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Extensions;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System.Linq;

    public class PaymentSummaryReportService : IPaymentSummaryReportService
    {
        private readonly IFundingStreamPeriodCensusDateRepository _fundingStreamPeriodCensusDateRepository;
        private readonly IWorkbookStorageRepository _workbookStorageRepository;

        public PaymentSummaryReportService(
            IFundingStreamPeriodCensusDateRepository fundingStreamPeriodCensusDateRepository,
            IWorkbookStorageRepository workbookStorageRepository)
        {
            _fundingStreamPeriodCensusDateRepository = fundingStreamPeriodCensusDateRepository;
            _workbookStorageRepository = workbookStorageRepository;
        }

        public async Task<bool> ShouldGeneratePaymentSummaryReport(DateTime currentTime, ConnectionInfo connectionInfo)
        {
            bool haveAllPaidCensusDatesPassedForCensusPeriod =
                await _fundingStreamPeriodCensusDateRepository.HaveAllPaidCensusDatesPassedForCensusPeriod(currentTime, connectionInfo);

            return haveAllPaidCensusDatesPassedForCensusPeriod && !HaveWeAlreadyGeneratedTheFile(currentTime);
        }

        public IReadOnlyCollection<PaymentSummaryLine> FilterOutUnnecessaryLines(IReadOnlyCollection<PaymentSummaryLine> lines)
        {
            var paymentSummaryLinesWithPayments = FilterPaymentSummaryLinesWithAllZeroPayments(lines);
            return FilterFspPaymentsWithAllZeroPayments(paymentSummaryLinesWithPayments);
        }

        private static IReadOnlyCollection<PaymentSummaryLine> FilterPaymentSummaryLinesWithAllZeroPayments(IReadOnlyCollection<PaymentSummaryLine> lines)
        {
            return lines.Where(line => line.Payments.Any(p => p.Payment != 0)).ToList();
        }

        private static IReadOnlyCollection<PaymentSummaryLine> FilterFspPaymentsWithAllZeroPayments(IReadOnlyCollection<PaymentSummaryLine> lines)
        {
            var fspsWithPayments = lines.SelectMany(line => line.Payments).GroupBy(payment =>payment.Fsp).ToList();

            var fspsWithZeroTotal = fspsWithPayments.Where(fspPayments => fspPayments.Sum(p => p.Payment) == 0)
                .Select(fspPayments => fspPayments.Key)
                .ToList();

            return lines.Select(
                line => new PaymentSummaryLine(
                    line.Ukprn,
                    line.ProviderName,
                    line.AgencyPayment,
                    line.Payments.Where(p => !fspsWithZeroTotal.Contains(p.Fsp)).ToList()))
                .ToList();
        }

        public IReadOnlyCollection<PaymentSummaryLine> FilterOutUnnecessaryLines1619(IReadOnlyCollection<PaymentSummaryLine> lines)
        {
            var paymentSummaryLinesWithPayments = FilterPaymentSummaryLinesWithAllZeroPayments1619(lines);
            return FilterFspPaymentsWithAllZeroPayments1619(paymentSummaryLinesWithPayments);
        }

        private static IReadOnlyCollection<PaymentSummaryLine> FilterPaymentSummaryLinesWithAllZeroPayments1619(IReadOnlyCollection<PaymentSummaryLine> lines)
        {
            return lines.Where(line => line.Total1619!=0).ToList();
        }

        private static IReadOnlyCollection<PaymentSummaryLine> FilterFspPaymentsWithAllZeroPayments1619(IReadOnlyCollection<PaymentSummaryLine> lines)
        {
            var fspsWithPayments = lines.SelectMany(line => line.Payments).GroupBy(payment=>payment.Fsp).ToList();

            var fspsWithZeroTotal = fspsWithPayments.Where(fspPayments => fspPayments.Sum(p => p.Payment) == 0)
                .Select(fspPayments => fspPayments.Key)
                .ToList();

            return lines.Select(
                line => new PaymentSummaryLine(
                    line.Ukprn,
                    line.ParentTradingName,
                    line.ChildUkprn,
                    line.ChildTradingName,
                    line.AgencyPayment1619,
                    line.Payments.Where(p => !fspsWithZeroTotal.Contains(p.Fsp)).ToList()))
                .ToList();
        }

        private bool HaveWeAlreadyGeneratedTheFile(DateTime currentTime)
        {
            ReportingPeriod reportingPeriod = new ReportingPeriod(currentTime);
            
            return _workbookStorageRepository.Exists(reportingPeriod.ToPaymentSummaryReportFilename());
        }
    }
}