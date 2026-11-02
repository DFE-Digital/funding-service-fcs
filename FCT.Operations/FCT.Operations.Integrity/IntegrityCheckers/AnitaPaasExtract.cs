namespace SFA.FCT.Operations.Integrity.IntegrityCheckers
{
    using System.Collections.Generic;
    using DTOs;
    using Repositories;
    using Services;
    using Utils;

    public class AnitaPaasExtract : IIntegrityChecker
    {
        private readonly PaasDeliverablePaymentLazyRepository _deliverablePaymentLazyRepository;

        public AnitaPaasExtract(PaasDeliverablePaymentLazyRepository deliverablePaymentLazyRepository)
        {
            _deliverablePaymentLazyRepository = deliverablePaymentLazyRepository;
        }

        public IntegrityCheckResult CheckValues()
        {
            var deliverablePayments = _deliverablePaymentLazyRepository.GetDeliverablePaymentsNotPaidExternally();

            CsvWriter<DeliverablePaymentWithFsp> csvWriter = new CsvWriter<DeliverablePaymentWithFsp>();
            string csvContent = csvWriter.CreateCsv(deliverablePayments ?? new List<DeliverablePaymentWithFsp>());

            return new IntegrityCheckResult(foundIssues: false, issuesCsv: csvContent);
        }
    }
}
